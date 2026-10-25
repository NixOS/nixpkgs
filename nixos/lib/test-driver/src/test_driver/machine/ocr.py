import os
import shutil
import subprocess
from collections.abc import Generator
from concurrent.futures import Future, ThreadPoolExecutor
from pathlib import Path

from test_driver.errors import MachineError

# Mode 11 recognizes sparse text; mode 12 also detects orientation and script.
# Keep mode 11 first and use mode 12 as an alternative when no match is found.
# https://tesseract-ocr.github.io/tessdoc/ImproveQuality.html#page-segmentation-method
_PSM_SPARSE_TEXT = 11
_PSM_SPARSE_TEXT_OSD = 12


def perform_ocr_on_screenshot(screenshot_path: Path) -> str:
    """
    Perform OCR on a screenshot that contains text.
    Returns a string with all words that could be found.
    """
    # This API returns a single string, so use the default mode 11 result.
    return next(iter_ocr_variants_on_screenshot(screenshot_path, False))[0]


def perform_ocr_variants_on_screenshot(
    screenshot_path: Path, variants: bool = True
) -> list[str]:
    """
    Same as perform_ocr_on_screenshot but will try alternative interpretations
    and optionally create variants of the image that can lead to more words
    being detected.
    Returns a string with words for each interpretation of each variant.
    """
    return [
        text
        for texts in iter_ocr_variants_on_screenshot(screenshot_path, variants)
        for text in texts
    ]


def iter_ocr_variants_on_screenshot(
    screenshot_path: Path, variants: bool = True
) -> Generator[list[str]]:
    """Yield batches of alternative textual interpretations, reusing the images.

    Additional interpretations are only computed when the caller requests
    the next batch of results.
    """
    if shutil.which("tesseract") is None:
        raise MachineError("OCR requested but `tesseract` is not available")

    # Tesseract runs parallel on up to 4 cores.
    # Docs suggest to run it with OMP_THREAD_LIMIT=1 for hundreds of parallel
    # runs. Our average test run is somewhere inbetween.
    # https://github.com/tesseract-ocr/tesseract/issues/3109
    nix_cores: str | None = os.environ.get("NIX_BUILD_CORES")
    cores: int = os.cpu_count() or 1 if nix_cores is None else int(nix_cores)
    workers: int = max(1, int(cores / 4))

    with ThreadPoolExecutor(max_workers=workers) as e:
        # The idea here is to let the first tesseract call run on the raw image
        # while the other two are preprocessed + tesseracted in parallel
        def tesseract_image(image: Path) -> tuple[Path, str]:
            return image, _run_tesseract(image, _PSM_SPARSE_TEXT)

        future_results: list[Future[tuple[Path, str]]] = [
            e.submit(tesseract_image, screenshot_path)
        ]
        if variants:

            def tesseract_processed(inverted: bool) -> tuple[Path, str]:
                processed_image = _preprocess_screenshot(screenshot_path, inverted)
                return tesseract_image(processed_image)

            future_results.append(e.submit(tesseract_processed, False))
            future_results.append(e.submit(tesseract_processed, True))
        results = [future.result() for future in future_results]
        yield [text for _, text in results]

        fallback_results = [
            e.submit(_run_tesseract, image, _PSM_SPARSE_TEXT_OSD)
            for image, _ in results
        ]
        yield [future.result() for future in fallback_results]


def _run_tesseract(image: Path, page_segmentation_mode: int) -> str:
    # tesseract --help-oem
    # OCR Engine modes (OEM):
    #  0|tesseract_only          Legacy engine only.
    #  1|lstm_only               Neural nets LSTM engine only.
    #  2|tesseract_lstm_combined Legacy + LSTM engines.
    #  3|default                 Default, based on what is available.
    ocr_engine_mode = 2

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
            str(page_segmentation_mode),
        ],
        capture_output=True,
    )
    if ret.returncode != 0:
        raise MachineError(f"OCR failed with exit code {ret.returncode}")
    return ret.stdout.decode("utf-8")


def _preprocess_screenshot(screenshot_path: Path, negate: bool = False) -> Path:
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
    )

    if ret.returncode != 0:
        raise MachineError(
            f"Image processing failed with exit code {ret.returncode}, stdout: {ret.stdout.decode()}, stderr: {ret.stderr.decode()}"
        )

    return out_file
