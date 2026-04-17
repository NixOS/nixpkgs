import atexit
import re
import tempfile
from pathlib import Path

from test_driver.test_reporter import TestReporter

GOLDEN_DIR = Path(__file__).parent / "golden"


def normalize_xml(xml: str) -> str:
    """Remove time attributes since they vary between runs."""
    return re.sub(r'\btime="[^"]*"', 'time="0"', xml)


def test_junit_xml_output() -> None:
    """Test that TestReporter produces expected JUnit XML output."""
    with tempfile.NamedTemporaryFile(mode="w", suffix=".xml", delete=False) as f:
        outfile = Path(f.name)

    reporter = TestReporter(outfile)

    # Create a passing subtest with stdout
    tc1 = reporter.start("my subtest")
    reporter.finish(tc1, stdout="Subtest log\n")

    # Create a failing subtest with stdout and stderr
    tc2 = reporter.start("failing subtest")
    reporter.finish(
        tc2,
        failure_message="test case failed",
        stdout="Some output\n",
        stderr="Error occurred\n",
    )

    # Manually close to write the file (normally done via atexit)
    atexit.unregister(reporter.close)
    reporter.close()

    actual = normalize_xml(outfile.read_text())
    golden_file = GOLDEN_DIR / "junit_xml_output.xml"

    if not golden_file.exists():
        golden_file.parent.mkdir(parents=True, exist_ok=True)
        golden_file.write_text(actual)
        raise AssertionError(
            f"Golden file did not exist, created it at {golden_file}. "
            "Please verify the output and re-run the test."
        )

    expected = normalize_xml(golden_file.read_text())
    assert actual == expected, f"JUnit XML output differs from golden file:\n{actual}"

    outfile.unlink()
