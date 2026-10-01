import os
import shutil
import subprocess
import threading
from collections.abc import Callable, Iterable, Iterator
from concurrent.futures import (
    FIRST_COMPLETED,
    CancelledError,
    Future,
    ThreadPoolExecutor,
    wait,
)
from contextlib import AbstractContextManager, ExitStack, nullcontext
from pathlib import Path

from test_driver.errors import MachineError


def perform_ocr_on_screenshot(screenshot_path: Path) -> str:
    """
    Perform OCR on a screenshot that contains text.
    Returns a string with all words that could be found.
    """
    return perform_ocr_variants_on_screenshot(screenshot_path, False)[0]


def perform_ocr_variants_on_screenshot(
    screenshot_path: Path, variants: bool = True
) -> list[str]:
    """
    Same as perform_ocr_on_screenshot but will create variants of the images
    that can lead to more words being detected.
    Returns a string with words for each variant.
    """
    with iter_ocr_variants(
        screenshot_cb=lambda: nullcontext(screenshot_path),
        include_processed_variants=variants,
    ) as results:
        return list(results)


class _CommandRunner:
    def __init__(self) -> None:
        self._cancelled = threading.Event()
        self._lock = threading.Lock()
        self._processes: set[subprocess.Popen[bytes]] = set()

    def run(self, args: list[str | Path]) -> tuple[int, bytes, bytes]:
        with self._lock:
            if self._cancelled.is_set():
                raise CancelledError
            process = subprocess.Popen(
                args,
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE,
            )
            self._processes.add(process)

        try:
            stdout, stderr = process.communicate()
        finally:
            with self._lock:
                self._processes.discard(process)

        assert process.returncode is not None
        return process.returncode, stdout, stderr

    def delay(self, seconds: float) -> None:
        if self._cancelled.wait(seconds):
            raise CancelledError

    def check_cancelled(self) -> None:
        if self._cancelled.is_set():
            raise CancelledError

    def cancel(self) -> None:
        with self._lock:
            self._cancelled.set()
            processes = tuple(self._processes)

        for process in processes:
            try:
                process.kill()
            except ProcessLookupError:
                pass


ScreenshotCallback = Callable[[], AbstractContextManager[Path]]


class OcrResultStream:
    def __init__(
        self,
        screenshot_cb: ScreenshotCallback,
        include_processed_variants: bool = True,
        *,
        retry_delays: Iterable[float] = (),
    ) -> None:
        self._screenshot_cb = screenshot_cb
        self._include_processed_variants = include_processed_variants
        self._retry_delays = tuple(retry_delays)
        self._runner = _CommandRunner()
        self._screenshot_lock = threading.Lock()
        self._exit_stack = ExitStack()
        self._executor: ThreadPoolExecutor | None = None
        self._futures: set[Future[str]] = set()
        self._ready: list[str] = []
        self._closed = False

    def __enter__(self) -> "OcrResultStream":
        if shutil.which("tesseract") is None:
            raise MachineError("OCR requested but `tesseract` is not available")

        # Tesseract runs parallel on up to 4 cores.
        # Docs suggest OMP_THREAD_LIMIT=1 for hundreds of parallel runs. Our
        # average test run is somewhere inbetween.
        # https://github.com/tesseract-ocr/tesseract/issues/3109
        nix_cores: str | None = os.environ.get("NIX_BUILD_CORES")
        cores: int = os.cpu_count() or 1 if nix_cores is None else int(nix_cores)
        workers: int = max(1, int(cores / 4)) + len(self._retry_delays)

        def tesseract_delayed(delay: float) -> str:
            self._runner.delay(delay)
            # Machine command channels are not safe for concurrent use.
            with self._screenshot_lock:
                self._runner.check_cancelled()
                with self._screenshot_cb() as delayed_screenshot_path:
                    return _run_tesseract(self._runner, delayed_screenshot_path)

        def tesseract_processed(screenshot_path: Path, inverted: bool) -> str:
            processed = _preprocess_screenshot(self._runner, screenshot_path, inverted)
            return _run_tesseract(self._runner, processed)

        try:
            screenshot_path = self._exit_stack.enter_context(self._screenshot_cb())
            self._executor = ThreadPoolExecutor(max_workers=workers)
            self._futures.add(
                self._executor.submit(_run_tesseract, self._runner, screenshot_path)
            )

            # Start delayed screenshots before the processed variants. Each
            # delayed job gets an executor slot so it cannot be queued behind
            # a slow image conversion.
            for delay in self._retry_delays:
                self._futures.add(self._executor.submit(tesseract_delayed, delay))

            if self._include_processed_variants:
                self._futures.add(
                    self._executor.submit(tesseract_processed, screenshot_path, False)
                )
                self._futures.add(
                    self._executor.submit(tesseract_processed, screenshot_path, True)
                )
        except BaseException:
            self.close()
            raise

        return self

    def __exit__(self, *_args: object) -> None:
        self.close()

    def __iter__(self) -> Iterator[str]:
        return self

    def __next__(self) -> str:
        result = self.next_result()
        if result is None:
            raise StopIteration
        return result

    def next_result(self, timeout: float | None = None) -> str | None:
        """Return the next completed OCR result, or None after a timeout."""
        if self._ready:
            return self._ready.pop()
        if not self._futures:
            return None

        completed, self._futures = wait(
            self._futures,
            timeout=timeout,
            return_when=FIRST_COMPLETED,
        )
        self._ready.extend(future.result() for future in completed)
        if self._ready:
            return self._ready.pop()
        return None

    def close(self) -> None:
        if self._closed:
            return
        self._closed = True

        self._runner.cancel()
        for future in self._futures:
            future.cancel()
        try:
            if self._executor is not None:
                self._executor.shutdown(wait=True, cancel_futures=True)
        finally:
            self._exit_stack.close()


def iter_ocr_variants(
    screenshot_cb: ScreenshotCallback,
    include_processed_variants: bool = True,
    *,
    retry_delays: Iterable[float] = (),
) -> OcrResultStream:
    """
    Take a screenshot and return OCR interpretations as they become available.
    Take fresh screenshots for raw OCR after each retry delay. Closing the
    result stream cancels unfinished work.
    """
    return OcrResultStream(
        screenshot_cb,
        include_processed_variants,
        retry_delays=retry_delays,
    )


def _run_tesseract(runner: _CommandRunner, image: Path) -> str:
    # tesseract --help-oem
    # OCR Engine modes (OEM):
    #  0|tesseract_only          Legacy engine only.
    #  1|lstm_only               Neural nets LSTM engine only.
    #  2|tesseract_lstm_combined Legacy + LSTM engines.
    #  3|default                 Default, based on what is available.
    ocr_engine_mode = 2

    returncode, stdout, _stderr = runner.run(
        [
            "tesseract",
            image,
            "-",
            "--oem",
            str(ocr_engine_mode),
            "-c",
            "debug_file=/dev/null",
            "--psm",
            "11",
        ]
    )
    if returncode != 0:
        raise MachineError(f"OCR failed with exit code {returncode}")
    return stdout.decode("utf-8")


def _preprocess_screenshot(
    runner: _CommandRunner, screenshot_path: Path, negate: bool = False
) -> Path:
    if shutil.which("magick") is None:
        raise MachineError("OCR requested but `magick` is not available")

    magick_args = [
        "-filter",
        "Catrom",
        "-density",
        "72",
        "-resample",
        "300",
        "-contrast",
        "-normalize",
        "-despeckle",
        "-type",
        "grayscale",
        "-sharpen",
        "1",
        "-posterize",
        "3",
    ]
    out_file = screenshot_path

    if negate:
        magick_args.append("-negate")
        out_file = out_file.with_name(f"{out_file.stem}.negative.png")
    else:
        out_file = out_file.with_name(f"{out_file.stem}.positive.png")

    magick_args += [
        "-gamma",
        "100",
        "-blur",
        "1x65535",
    ]

    returncode, stdout, stderr = runner.run(
        ["magick", "convert"] + magick_args + [screenshot_path, out_file]
    )

    if returncode != 0:
        raise MachineError(
            f"Image processing failed with exit code {returncode}, stdout: {stdout.decode()}, stderr: {stderr.decode()}"
        )

    return out_file
