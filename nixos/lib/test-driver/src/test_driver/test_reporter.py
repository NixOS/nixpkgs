import atexit
import time
from pathlib import Path

from junitparser import Failure, JUnitXml, TestCase, TestSuite


class TestReporter:
    """Records test results and writes JUnit XML on close."""

    def __init__(self, outfile: Path) -> None:
        self.outfile = outfile
        self._suite = TestSuite("NixOS integration test")
        self._main = TestCase("main")
        self._main_start = time.time()
        atexit.register(self.close)

    def start(self, name: str) -> TestCase:
        tc = TestCase(name)
        tc.time = time.time()  # store start time, replaced with duration on finish
        self._suite.add_testcase(tc)
        return tc

    def finish(
        self,
        tc: TestCase,
        failure_message: str | None = None,
        stdout: str | None = None,
        stderr: str | None = None,
    ) -> None:
        tc.time = time.time() - tc.time
        if failure_message:
            tc.result = [Failure(failure_message)]
        if stdout:
            tc.system_out = stdout
        if stderr:
            tc.system_err = stderr

    def close(self) -> None:
        self._main.time = time.time() - self._main_start
        self._suite.add_testcase(self._main)

        xml = JUnitXml()
        xml.add_testsuite(self._suite)
        xml.update_statistics()
        self.outfile.parent.mkdir(parents=True, exist_ok=True)
        xml.write(str(self.outfile), pretty=True)
