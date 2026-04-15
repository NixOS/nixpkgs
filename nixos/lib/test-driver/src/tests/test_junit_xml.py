import tempfile
from pathlib import Path

from test_driver.logger import JunitXMLLogger

GOLDEN_DIR = Path(__file__).parent / "golden"


def test_junit_xml_output() -> None:
    """Test that JunitXMLLogger produces expected JUnit XML output."""
    with tempfile.NamedTemporaryFile(mode="w", suffix=".xml", delete=False) as f:
        outfile = Path(f.name)

    logger = JunitXMLLogger(outfile)

    # Log some messages to main test case
    logger.log("Starting test...")
    logger.info("Log message 1")

    # Create a subtest
    with logger.subtest("my subtest"):
        logger.log("Subtest log")

    # Create a failing subtest
    with logger.subtest("failing subtest"):
        logger.log("Some output")
        logger.error("Error occurred")

    # Manually close to write the file (normally done via atexit)
    import atexit

    atexit.unregister(logger.close)
    logger.close()

    actual = outfile.read_text()
    golden_file = GOLDEN_DIR / "junit_xml_output.xml"

    if not golden_file.exists():
        golden_file.parent.mkdir(parents=True, exist_ok=True)
        golden_file.write_text(actual)
        raise AssertionError(
            f"Golden file did not exist, created it at {golden_file}. "
            "Please verify the output and re-run the test."
        )

    expected = golden_file.read_text()
    assert actual == expected, f"JUnit XML output differs from golden file:\n{actual}"

    outfile.unlink()
