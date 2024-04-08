import codecs
import os
import sys
import time
import unicodedata
from abc import ABC, abstractmethod
from contextlib import ExitStack, contextmanager
from queue import Empty, Queue
from typing import Any, Dict, Iterator, List
from xml.sax.saxutils import XMLGenerator
from xml.sax.xmlreader import AttributesImpl

from colorama import Fore, Style


class AbstractLogger(ABC):
    @abstractmethod
    def log(self, message: str, attributes: Dict[str, str] = {}) -> None:
        pass

    @abstractmethod
    @contextmanager
    def subtest(self, name: str, attributes: Dict[str, str] = {}) -> Iterator[None]:
        pass

    @abstractmethod
    @contextmanager
    def nested(self, message: str, attributes: Dict[str, str] = {}) -> Iterator[None]:
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
    def log_serial(self, message: str, machine: str) -> None:
        pass

    @abstractmethod
    def print_serial_logs(self, enable: bool) -> None:
        pass


class CompositeLogger(AbstractLogger):
    def __init__(self, logger_list: List[AbstractLogger]) -> None:
        self.logger_list = logger_list

    def add_logger(self, logger: AbstractLogger) -> None:
        self.logger_list.append(logger)

    def log(self, message: str, attributes: Dict[str, str] = {}) -> None:
        for logger in self.logger_list:
            logger.log(message, attributes)

    @contextmanager
    def subtest(self, name: str, attributes: Dict[str, str] = {}) -> Iterator[None]:
        with ExitStack() as stack:
            for logger in self.logger_list:
                stack.enter_context(logger.subtest(name, attributes))
            yield

    @contextmanager
    def nested(self, message: str, attributes: Dict[str, str] = {}) -> Iterator[None]:
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

    def maybe_prefix(self, message: str, attributes: Dict[str, str]) -> str:
        if "machine" in attributes:
            return f"{attributes['machine']}: {message}"
        return message

    @staticmethod
    def _eprint(*args: object, **kwargs: Any) -> None:
        print(*args, file=sys.stderr, **kwargs)

    def log(self, message: str, attributes: Dict[str, str] = {}) -> None:
        self._eprint(self.maybe_prefix(message, attributes))

    @contextmanager
    def subtest(self, name: str, attributes: Dict[str, str] = {}) -> Iterator[None]:
        with self.nested("subtest: " + name, attributes):
            yield

    @contextmanager
    def nested(self, message: str, attributes: Dict[str, str] = {}) -> Iterator[None]:
        self._eprint(
            self.maybe_prefix(
                Style.BRIGHT + Fore.GREEN + message + Style.RESET_ALL, attributes
            )
        )

        tic = time.time()
        yield
        toc = time.time()
        self.log(f"(finished: {message}, in {toc - tic:.2f} seconds)")

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


class XMLLogger(AbstractLogger):
    def __init__(self) -> None:
        self.logfile = os.environ.get("LOGFILE", "/dev/null")
        self.logfile_handle = codecs.open(self.logfile, "wb")
        self.xml = XMLGenerator(self.logfile_handle, encoding="utf-8")
        self.queue: "Queue[Dict[str, str]]" = Queue()

        self._print_serial_logs = True

        self.xml.startDocument()
        self.xml.startElement("logfile", attrs=AttributesImpl({}))

    def close(self) -> None:
        self.xml.endElement("logfile")
        self.xml.endDocument()
        self.logfile_handle.close()

    def sanitise(self, message: str) -> str:
        return "".join(ch for ch in message if unicodedata.category(ch)[0] != "C")

    def maybe_prefix(self, message: str, attributes: Dict[str, str]) -> str:
        if "machine" in attributes:
            return f"{attributes['machine']}: {message}"
        return message

    def log_line(self, message: str, attributes: Dict[str, str]) -> None:
        self.xml.startElement("line", attrs=AttributesImpl(attributes))
        self.xml.characters(message)
        self.xml.endElement("line")

    def info(self, *args, **kwargs) -> None:  # type: ignore
        self.log(*args, **kwargs)

    def warning(self, *args, **kwargs) -> None:  # type: ignore
        self.log(*args, **kwargs)

    def error(self, *args, **kwargs) -> None:  # type: ignore
        self.log(*args, **kwargs)

    def log(self, message: str, attributes: Dict[str, str] = {}) -> None:
        self.drain_log_queue()
        self.log_line(message, attributes)

    def print_serial_logs(self, enable: bool) -> None:
        self._print_serial_logs = enable

    def log_serial(self, message: str, machine: str) -> None:
        if not self._print_serial_logs:
            return

        self.enqueue({"msg": message, "machine": machine, "type": "serial"})

    def enqueue(self, item: Dict[str, str]) -> None:
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
    def subtest(self, name: str, attributes: Dict[str, str] = {}) -> Iterator[None]:
        with self.nested("subtest: " + name, attributes):
            yield

    @contextmanager
    def nested(self, message: str, attributes: Dict[str, str] = {}) -> Iterator[None]:
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


terminal_logger = TerminalLogger()
xml_logger = XMLLogger()
rootlog: AbstractLogger = CompositeLogger([terminal_logger, xml_logger])
