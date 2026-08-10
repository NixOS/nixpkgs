{
  name = "ocr";

  nodes = { };

  testScript = ''
    import subprocess
    import threading
    import time
    from pathlib import Path
    from unittest.mock import patch

    from test_driver.machine import ocr


    timeout = 0.01
    expired = subprocess.TimeoutExpired(["tesseract"], timeout)
    with patch.object(ocr.subprocess, "run", side_effect=expired) as run:
        assert ocr._run_tesseract(Path("input.png"), timeout) == ""
        assert run.call_args.kwargs["timeout"] == timeout

    completed = subprocess.CompletedProcess(["tesseract"], 0, stdout=b"text")
    with patch.object(ocr.subprocess, "run", return_value=completed) as run:
        assert ocr._run_tesseract(Path("input.png")) == "text"
        assert run.call_args.kwargs["timeout"] is None

    input_path = Path("input.png")
    variant_timeouts = {}

    def record_timeout(image: Path, worker_timeout: float | None) -> str:
        variant_timeouts[image] = worker_timeout
        return "text"

    def slow_preprocessing(
        image: Path, inverted: bool, _timeout: float | None
    ) -> Path:
        time.sleep(0.03)
        suffix = "negative" if inverted else "positive"
        return image.with_name(f"{image.name}.{suffix}")

    with (
        patch.dict(ocr.os.environ, {"NIX_BUILD_CORES": "12"}),
        patch.object(ocr.shutil, "which", return_value="/bin/true"),
        patch.object(ocr, "_run_tesseract", side_effect=record_timeout),
        patch.object(
            ocr, "_preprocess_screenshot", side_effect=slow_preprocessing
        ),
    ):
        assert ocr.perform_ocr_variants_on_screenshot(
            input_path, timeout=0.1
        ) == ["text", "text", "text"]

    raw_timeout = variant_timeouts[input_path]
    assert raw_timeout is not None
    processed_timeouts = [
        value
        for path, value in variant_timeouts.items()
        if path != input_path and value is not None
    ]
    assert len(processed_timeouts) == 2
    assert max(processed_timeouts) < raw_timeout - 0.02

    worker_threads = []

    def slow_worker(_image: Path, _timeout: float | None) -> str:
        worker_threads.append(threading.current_thread())
        time.sleep(0.05)
        return "late"

    with (
        patch.object(ocr.shutil, "which", return_value="/bin/true"),
        patch.object(ocr, "_run_tesseract", side_effect=slow_worker),
    ):
        assert ocr.perform_ocr_variants_on_screenshot(
            Path("input.png"), variants=False, timeout=0.01
        ) == [""]

    assert worker_threads
    assert all(not worker.is_alive() for worker in worker_threads)

    with patch.object(ocr.shutil, "which", return_value="/bin/true"):
        assert ocr.perform_ocr_variants_on_screenshot(
            Path("input.png"), timeout=0
        ) == ["", "", ""]
  '';
}
