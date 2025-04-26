import atexit
import codecs
import os
import sys
import time
import unicodedata
from abc import ABC, abstractmethod
from collections.abc import Iterator
from contextlib import ExitStack, contextmanager
from pathlib import Path
from queue import Empty, Queue
from typing import Any
from xml.sax.saxutils import XMLGenerator
from xml.sax.xmlreader import AttributesImpl

from colorama import Fore, Style
from junit_xml import TestCase, TestSuite


class AbstractLogger(ABC):
    @abstractmethod
    def log(self, message: str, attributes: dict[str, str] = {}) -> None:
        pass

    @abstractmethod
    @contextmanager
    def subtest(self, name: str, attributes: dict[str, str] = {}) -> Iterator[None]:
        pass

    @abstractmethod
    @contextmanager
    def nested(self, message: str, attributes: dict[str, str] = {}) -> Iterator[None]:
        pass

    @abstractmethod
    def info(self, *args, **kwargs) -> None:  # type: ignore
        pass

    @abstractmethod
    def warning(self, *args, **kwargs) -> None:  # type: ignore
        pass

    @abstractmethod
    def error(self, *args, **kwargs) -> None:  # type: ignore
        pass

    @abstractmethod
    def log_test_error(self, *args, **kwargs) -> None:  # type:ignore
        pass

    @abstractmethod
    def log_serial(self, message: str, machine: str) -> None:
        pass

    @abstractmethod
    def print_serial_logs(self, enable: bool) -> None:
        pass


class JunitXMLLogger(AbstractLogger):
    class TestCaseState:
        def __init__(self) -> None:
            self.stdout = ""
            self.stderr = ""
            self.failure = False

    def __init__(self, outfile: Path) -> None:
        self.tests: dict[str, JunitXMLLogger.TestCaseState] = {
            "main": self.TestCaseState()
        }
        self.currentSubtest = "main"
        self.outfile: Path = outfile
        self._print_serial_logs = True
        atexit.register(self.close)

    def log(self, message: str, attributes: dict[str, str] = {}) -> None:
        self.tests[self.currentSubtest].stdout += message + os.linesep

    @contextmanager
    def subtest(self, name: str, attributes: dict[str, str] = {}) -> Iterator[None]:
        old_test = self.currentSubtest
        self.tests.setdefault(name, self.TestCaseState())
        self.currentSubtest = name

        yield

        self.currentSubtest = old_test

    @contextmanager
    def nested(self, message: str, attributes: dict[str, str] = {}) -> Iterator[None]:
        self.log(message)
        yield

    def info(self, *args, **kwargs) -> None:  # type: ignore
        self.tests[self.currentSubtest].stdout += args[0] + os.linesep

    def warning(self, *args, **kwargs) -> None:  # type: ignore
        self.tests[self.currentSubtest].stdout += args[0] + os.linesep

    def error(self, *args, **kwargs) -> None:  # type: ignore
        self.tests[self.currentSubtest].stderr += args[0] + os.linesep
        self.tests[self.currentSubtest].failure = True

    def log_test_error(self, *args, **kwargs) -> None:  # type: ignore
        self.error(*args, **kwargs)

    def log_serial(self, message: str, machine: str) -> None:
        if not self._print_serial_logs:
            return

        self.log(f"{machine} # {message}")

    def print_serial_logs(self, enable: bool) -> None:
        self._print_serial_logs = enable

    def close(self) -> None:
        with open(self.outfile, "w") as f:
            test_cases = []
            for name, test_case_state in self.tests.items():
                tc = TestCase(
                    name,
                    stdout=test_case_state.stdout,
                    stderr=test_case_state.stderr,
                )
                if test_case_state.failure:
                    tc.add_failure_info("test case failed")

                test_cases.append(tc)
            ts = TestSuite("NixOS integration test", test_cases)
            f.write(TestSuite.to_xml_string([ts]))


class CompositeLogger(AbstractLogger):
    def __init__(self, logger_list: list[AbstractLogger]) -> None:
        self.logger_list = logger_list

    def add_logger(self, logger: AbstractLogger) -> None:
        self.logger_list.append(logger)

    def log(self, message: str, attributes: dict[str, str] = {}) -> None:
        for logger in self.logger_list:
            logger.log(message, attributes)

    @contextmanager
    def subtest(self, name: str, attributes: dict[str, str] = {}) -> Iterator[None]:
        with ExitStack() as stack:
            for logger in self.logger_list:
                stack.enter_context(logger.subtest(name, attributes))
            yield

    @contextmanager
    def nested(self, message: str, attributes: dict[str, str] = {}) -> Iterator[None]:
        with ExitStack() as stack:
            for logger in self.logger_list:
                stack.enter_context(logger.nested(message, attributes))
            yield

    def info(self, *args, **kwargs) -> None:  # type: ignore
        for logger in self.logger_list:
            logger.info(*args, **kwargs)

    def warning(self, *args, **kwargs) -> None:  # type: ignore
        for logger in self.logger_list:
            logger.warning(*args, **kwargs)

    def log_test_error(self, *args, **kwargs) -> None:  # type: ignore
        for logger in self.logger_list:
            logger.log_test_error(*args, **kwargs)

    def error(self, *args, **kwargs) -> None:  # type: ignore
        for logger in self.logger_list:
            logger.error(*args, **kwargs)
        sys.exit(1)

    def print_serial_logs(self, enable: bool) -> None:
        for logger in self.logger_list:
            logger.print_serial_logs(enable)

    def log_serial(self, message: str, machine: str) -> None:
        for logger in self.logger_list:
            logger.log_serial(message, machine)


class TerminalLogger(AbstractLogger):
    def __init__(self) -> None:
        self._print_serial_logs = True

    def maybe_prefix(self, message: str, attributes: dict[str, str]) -> str:
        if "machine" in attributes:
            return f"{attributes['machine']}: {message}"
        return message

    @staticmethod
    def _eprint(*args: object, **kwargs: Any) -> None:
        print(*args, file=sys.stderr, **kwargs)

    def log(self, message: str, attributes: dict[str, str] = {}) -> None:
        self._eprint(self.maybe_prefix(message, attributes))

    @contextmanager
    def subtest(self, name: str, attributes: dict[str, str] = {}) -> Iterator[None]:
        with self.nested("subtest: " + name, attributes):
            yield

    @contextmanager
    def nested(self, message: str, attributes: dict[str, str] = {}) -> Iterator[None]:
        self._eprint(
            self.maybe_prefix(
                Style.BRIGHT + Fore.GREEN + message + Style.RESET_ALL, attributes
            )
        )

        tic = time.time()
        yield
        toc = time.time()
        self.log(f"(finished: {message}, in {toc - tic:.2f} seconds)", attributes)

    def info(self, *args, **kwargs) -> None:  # type: ignore
        self.log(*args, **kwargs)

    def warning(self, *args, **kwargs) -> None:  # type: ignore
        self.log(*args, **kwargs)

    def error(self, *args, **kwargs) -> None:  # type: ignore
        self.log(*args, **kwargs)

    def print_serial_logs(self, enable: bool) -> None:
        self._print_serial_logs = enable

    def log_serial(self, message: str, machine: str) -> None:
        if not self._print_serial_logs:
            return

        self._eprint(Style.DIM + f"{machine} # {message}" + Style.RESET_ALL)

    def log_test_error(self, *args, **kwargs) -> None:  # type: ignore
        prefix = Fore.RED + "!!! " + Style.RESET_ALL
        # NOTE: using `warning` instead of `error` to ensure it does not exit after printing the first log
        self.warning(f"{prefix}{args[0]}", *args[1:], **kwargs)


class XMLLogger(AbstractLogger):
    def __init__(self, outfile: str) -> None:
        self.logfile_handle = codecs.open(outfile, "wb")
        self.xml = XMLGenerator(self.logfile_handle, encoding="utf-8")
        self.queue: Queue[dict[str, str]] = Queue()

        self._print_serial_logs = True

        self.xml.startDocument()
        self.xml.startElement("logfile", attrs=AttributesImpl({}))

    def close(self) -> None:
        self.xml.endElement("logfile")
        self.xml.endDocument()
        self.logfile_handle.close()

    def sanitise(self, message: str) -> str:
        return "".join(ch for ch in message if unicodedata.category(ch)[0] != "C")

    def maybe_prefix(self, message: str, attributes: dict[str, str]) -> str:
        if "machine" in attributes:
            return f"{attributes['machine']}: {message}"
        return message

    def log_line(self, message: str, attributes: dict[str, str]) -> None:
        self.xml.startElement("line", attrs=AttributesImpl(attributes))
        self.xml.characters(message)
        self.xml.endElement("line")

    def info(self, *args, **kwargs) -> None:  # type: ignore
        self.log(*args, **kwargs)

    def warning(self, *args, **kwargs) -> None:  # type: ignore
        self.log(*args, **kwargs)

    def error(self, *args, **kwargs) -> None:  # type: ignore
        self.log(*args, **kwargs)

    def log_test_error(self, *args, **kwargs) -> None:  # type: ignore
        self.log(*args, **kwargs)

    def log(self, message: str, attributes: dict[str, str] = {}) -> None:
        self.drain_log_queue()
        self.log_line(message, attributes)

    def print_serial_logs(self, enable: bool) -> None:
        self._print_serial_logs = enable

    def log_serial(self, message: str, machine: str) -> None:
        if not self._print_serial_logs:
            return

        self.enqueue({"msg": message, "machine": machine, "type": "serial"})

    def enqueue(self, item: dict[str, str]) -> None:
        self.queue.put(item)

    def drain_log_queue(self) -> None:
        try:
            while True:
                item = self.queue.get_nowait()
                msg = self.sanitise(item["msg"])
                del item["msg"]
                self.log_line(msg, item)
        except Empty:
            pass

    @contextmanager
    def subtest(self, name: str, attributes: dict[str, str] = {}) -> Iterator[None]:
        with self.nested("subtest: " + name, attributes):
            yield

    @contextmanager
    def nested(self, message: str, attributes: dict[str, str] = {}) -> Iterator[None]:
        self.xml.startElement("nest", attrs=AttributesImpl({}))
        self.xml.startElement("head", attrs=AttributesImpl(attributes))
        self.xml.characters(message)
        self.xml.endElement("head")

        tic = time.time()
        self.drain_log_queue()
        yield
        self.drain_log_queue()
        toc = time.time()
        self.log(f"(finished: {message}, in {toc - tic:.2f} seconds)")

        self.xml.endElement("nest")
