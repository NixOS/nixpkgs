from contextlib import contextmanager
from typing import Tuple, Dict, Iterator
from queue import Queue, Empty
from xml.sax.saxutils import XMLGenerator
from colorama import Style
import codecs
import os
import time
import unicodedata

import common


class Logger:
    def __init__(self) -> None:
        self.enable_serial_logs = True  # switchable at runtime

    def release(self) -> None:
        pass

    def log_machinestate(self, message: str, _: Dict[str, str] = {}) -> None:
        print(message)

    def log_serial(self, message: str, _: Dict[str, str] = {}) -> None:
        if self.enable_serial_logs:
            print(Style.DIM + message + Style.RESET_ALL)

    __call__ = log_machinestate

    @contextmanager
    def nested(self, message: str) -> Iterator[None]:
        self.log_machinestate(message)
        yield


def sanitise(message: str) -> str:
    return "".join(ch for ch in message if unicodedata.category(ch)[0] != "C")


class XmlLogger(Logger):
    def __init__(self) -> None:
        Logger.__init__(self)

        self.logfile = os.environ.get("LOGFILE")
        if self.logfile is None:
            raise Exception(
                "Using XmlLogger, but LOGFILE env variable not defined")
        self.logfile_handle = codecs.open(self.logfile, "wb")
        self.xml = XMLGenerator(self.logfile_handle, encoding="utf-8")
        self.queue: "Queue[Tuple[str,Dict[str, str]]]" = Queue()

        self.xml.startDocument()
        self.xml.startElement("logfile", attrs={})

    def release(self) -> None:
        self.xml.endElement("logfile")
        self.xml.endDocument()
        self.logfile_handle.close()

    def _log_line(self, message: str, attributes: Dict[str, str]) -> None:
        self.xml.startElement("line", attributes)
        self.xml.characters(message)
        self.xml.endElement("line")

    def log_machinestate(self, message: str, attributes: Dict[str, str] = {}) -> None:
        common.eprint(message, attributes)
        self._drain_log_queue()
        self._log_line(message, attributes)

    def log_serial(self, message: str, attributes: Dict[str, str] = {}) -> None:
        self._enqueue((message, {"type": "serial"}))
        if self.enable_serial_logs:
            common.eprint(Style.DIM + message + Style.RESET_ALL)

    def _enqueue(self, message: Tuple[str, Dict[str, str]]) -> None:
        self.queue.put(message)

    def _drain_log_queue(self) -> None:
        try:
            while True:
                item = self.queue.get_nowait()
                (msg, attributes) = item
                self._log_line(sanitise(msg), attributes)
        except Empty:
            pass

    @contextmanager
    def nested(self, message: str, attributes: Dict[str, str] = {}) -> Iterator[None]:
        common.eprint(message)

        self.xml.startElement("nest", attrs={})
        self.xml.startElement("head", attributes)
        self.xml.characters(message)
        self.xml.endElement("head")

        tic = time.time()
        self._drain_log_queue()
        yield
        self._drain_log_queue()
        toc = time.time()
        self.log_machinestate(f"({(toc-tic):.2f} seconds)")

        self.xml.endElement("nest")
