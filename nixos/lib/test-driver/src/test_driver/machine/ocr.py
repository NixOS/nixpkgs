import os
import shutil
import subprocess
from concurrent.futures import Future, ThreadPoolExecutor
from pathlib import Path

from test_driver.errors import MachineError


def perform_ocr_on_screenshot(screenshot_path: Path) -> str:
    """
    Perform OCR on a screenshot that contains text.
    Returns a string with all words that could be found.
    """
    variants = perform_ocr_variants_on_screenshot(screenshot_path, False)[0]
    if len(variants) != 1:
        raise MachineError(f"Received wrong number of OCR results: {len(variants)}")
    return variants[0]


def perform_ocr_variants_on_screenshot(
    screenshot_path: Path, variants: bool = True
) -> list[str]:
    """
    Same as perform_ocr_on_screenshot but will create variants of the images
    that can lead to more words being detected.
    Returns a string with words for each variant.
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
        future_results: list[Future] = [e.submit(_run_tesseract, screenshot_path)]
        if variants:

            def tesseract_processed(inverted: bool) -> str:
                return _run_tesseract(_preprocess_screenshot(screenshot_path, inverted))

            future_results.append(e.submit(tesseract_processed, False))
            future_results.append(e.submit(tesseract_processed, True))
        return [future.result() for future in future_results]


def _run_tesseract(image: Path) -> str:
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
            "11",
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
