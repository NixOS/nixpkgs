import shutil
import subprocess

from test_driver.errors import MachineError


def perform_ocr_on_screenshot(screenshot_path: str) -> str:
    """
    Perform OCR on a screenshot that contains text.
    Returns a string with all words that could be found.
    """
    return perform_ocr_variants_on_screenshot(screenshot_path, False)[0]


def perform_ocr_variants_on_screenshot(
    screenshot_path: str, variants: bool = True
) -> list[str]:
    """
    Same as perform_ocr_on_screenshot but will create variants of the images
    that can lead to more words being detected.
    Returns a string with words for each variant.
    """
    if shutil.which("tesseract") is None:
        raise MachineError("OCR requested but `tesseract` is not available")

    # tesseract --help-oem
    # OCR Engine modes (OEM):
    #  0|tesseract_only          Legacy engine only.
    #  1|lstm_only               Neural nets LSTM engine only.
    #  2|tesseract_lstm_combined Legacy + LSTM engines.
    #  3|default                 Default, based on what is available.
    model_ids: list[int] = [0, 1, 2] if variants else [3]

    image_paths = [
        screenshot_path,
        _preprocess_screenshot(screenshot_path, negate=False),
        _preprocess_screenshot(screenshot_path, negate=True),
    ]

    def run_tesseract(image: str, model_id: int) -> str:
        ret = subprocess.run(
            [
                "tesseract",
                image,
                "-",
                "--oem",
                str(model_id),
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

    return [
        run_tesseract(image, model_id)
        for image in image_paths
        for model_id in model_ids
    ]


def _preprocess_screenshot(screenshot_path: str, negate: bool = False) -> str:
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
        out_file += ".negative"

    magick_args += [
        "-gamma",
        "100",
        "-blur",
        "1x65535",
    ]
    out_file += ".png"

    ret = subprocess.run(
        ["magick", "convert"] + magick_args + [screenshot_path, out_file],
        capture_output=True,
    )

    if ret.returncode != 0:
        raise MachineError(
            f"Image processing failed with exit code {ret.returncode}, stdout: {ret.stdout.decode()}, stderr: {ret.stderr.decode()}"
        )

    return out_file
