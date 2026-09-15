import os
import shutil
import subprocess
import time
from concurrent.futures import Future, ThreadPoolExecutor
from concurrent.futures import TimeoutError as FuturesTimeoutError
from pathlib import Path

from test_driver.errors import MachineError


def perform_ocr_on_screenshot(
    screenshot_path: Path, timeout: float | None = None
) -> str:
    """
    Perform OCR on a screenshot that contains text.
    If timeout is set, the OCR operation is limited to that many seconds.
    Returns a string with all words that could be found, or an empty string if
    OCR times out.
    """
    return perform_ocr_variants_on_screenshot(screenshot_path, False, timeout)[0]


def perform_ocr_variants_on_screenshot(
    screenshot_path: Path, variants: bool = True, timeout: float | None = None
) -> list[str]:
    """
    Same as perform_ocr_on_screenshot but will create variants of the images
    that can lead to more words being detected.
    If timeout is set, preprocessing and all variants share that time budget.
    Returns recognized text for each variant. A timed-out variant produces an
    empty string.
    """
    if shutil.which("tesseract") is None:
        raise MachineError("OCR requested but `tesseract` is not available")

    processed_inversions = (False, True) if variants else ()
    if timeout is not None and timeout <= 0:
        return [""] * (1 + len(processed_inversions))

    deadline = None if timeout is None else time.monotonic() + timeout

    def remaining_time() -> float | None:
        if deadline is None:
            return None
        return max(0, deadline - time.monotonic())

    # Tesseract runs parallel on up to 4 cores.
    # Docs suggest to run it with OMP_THREAD_LIMIT=1 for hundreds of parallel
    # runs. Our average test run is somewhere inbetween.
    # https://github.com/tesseract-ocr/tesseract/issues/3109
    nix_cores: str | None = os.environ.get("NIX_BUILD_CORES")
    cores: int = os.cpu_count() or 1 if nix_cores is None else int(nix_cores)
    workers: int = max(1, int(cores / 4))

    executor = ThreadPoolExecutor(max_workers=workers)
    try:
        # The idea here is to let the first tesseract call run on the raw image
        # while the other two are preprocessed + tesseracted in parallel

        def tesseract_raw() -> str:
            worker_timeout = remaining_time()
            if worker_timeout is not None and worker_timeout <= 0:
                return ""
            return _run_tesseract(screenshot_path, worker_timeout)

        future_results: list[Future[str]] = [executor.submit(tesseract_raw)]
        if processed_inversions:

            def tesseract_processed(inverted: bool) -> str:
                preprocess_timeout = remaining_time()
                if preprocess_timeout is not None and preprocess_timeout <= 0:
                    return ""
                try:
                    processed = _preprocess_screenshot(
                        screenshot_path, inverted, preprocess_timeout
                    )
                except subprocess.TimeoutExpired:
                    return ""
                return _run_tesseract(
                    processed,
                    remaining_time(),
                )

            future_results.extend(
                executor.submit(tesseract_processed, inverted)
                for inverted in processed_inversions
            )

        results: list[str] = []
        for future in future_results:
            try:
                results.append(future.result(timeout=remaining_time()))
            except FuturesTimeoutError:
                results.append("")
        return results
    finally:
        # Each running worker has the same deadline. Wait for subprocess timeout
        # cleanup before the screenshot's temporary directory is removed.
        executor.shutdown(wait=True, cancel_futures=True)


def _run_tesseract(image: Path, timeout: float | None = None) -> str:
    # tesseract --help-oem
    # OCR Engine modes (OEM):
    #  0|tesseract_only          Legacy engine only.
    #  1|lstm_only               Neural nets LSTM engine only.
    #  2|tesseract_lstm_combined Legacy + LSTM engines.
    #  3|default                 Default, based on what is available.
    ocr_engine_mode = 2

    try:
        ret = subprocess.run(
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
            ],
            capture_output=True,
            timeout=timeout,
        )
    except subprocess.TimeoutExpired:
        return ""
    if ret.returncode != 0:
        raise MachineError(f"OCR failed with exit code {ret.returncode}")
    return ret.stdout.decode("utf-8")


def _preprocess_screenshot(
    screenshot_path: Path,
    negate: bool = False,
    timeout: float | None = None,
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

    ret = subprocess.run(
        ["magick", "convert"] + magick_args + [screenshot_path, out_file],
        capture_output=True,
        timeout=timeout,
    )

    if ret.returncode != 0:
        raise MachineError(
            f"Image processing failed with exit code {ret.returncode}, stdout: {ret.stdout.decode()}, stderr: {ret.stderr.decode()}"
        )

    return out_file
