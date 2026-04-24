import atexit
import tempfile
import xml.etree.ElementTree as ET
from pathlib import Path

from test_driver.logger import JunitXMLLogger

GOLDEN_FILE = Path(__file__).parent / "golden" / "junit_xml_output.xml"


def elements_equal(e1: ET.Element, e2: ET.Element) -> bool:
    """Recursively compare two XML elements for equality."""
    if e1.tag != e2.tag:
        return False
    if e1.attrib != e2.attrib:
        return False
    if (e1.text or "").strip() != (e2.text or "").strip():
        return False
    if (e1.tail or "").strip() != (e2.tail or "").strip():
        return False
    if len(e1) != len(e2):
        return False
    return all(elements_equal(c1, c2) for c1, c2 in zip(e1, e2, strict=True))


def test_junit_xml_output() -> None:
    """Test that JunitXMLLogger produces expected JUnit XML output."""
    with tempfile.TemporaryDirectory() as tmpdir:
        outfile = Path(tmpdir) / "output.xml"

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
        atexit.unregister(logger.close)
        logger.close()

        actual_tree = ET.parse(outfile)
        expected_tree = ET.parse(GOLDEN_FILE)

        assert elements_equal(actual_tree.getroot(), expected_tree.getroot()), (
            f"JUnit XML output differs from golden file:\n{outfile.read_text()}"
        )
