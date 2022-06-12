from colorama import Style, Fore
from contextlib import contextmanager
from typing import Any, Dict, Iterator
from queue import Queue, Empty
from xml.sax.saxutils import XMLGenerator
import codecs
import os
import sys
import time
import unicodedata


class Logger:
    def __init__(self) -> None:
        self.logfile = os.environ.get("LOGFILE", "/dev/null")
        self.logfile_handle = codecs.open(self.logfile, "wb")
        self.xml = XMLGenerator(self.logfile_handle, encoding="utf-8")
        self.queue: "Queue[Dict[str, str]]" = Queue()

        self.xml.startDocument()
        self.xml.startElement("logfile", attrs={})

        self._print_serial_logs = True

    @staticmethod
    def _eprint(*args: object, **kwargs: Any) -> None:
        print(*args, file=sys.stderr, **kwargs)

    def close(self) -> None:
        self.xml.endElement("logfile")
        self.xml.endDocument()
        self.logfile_handle.close()

    def sanitise(self, message: str) -> str:
        return "".join(ch for ch in message if unicodedata.category(ch)[0] != "C")

    def maybe_prefix(self, message: str, attributes: Dict[str, str]) -> str:
        if "machine" in attributes:
            return "{}: {}".format(attributes["machine"], message)
        return message

    def log_line(self, message: str, attributes: Dict[str, str]) -> None:
        self.xml.startElement("line", attributes)
        self.xml.characters(message)
        self.xml.endElement("line")

    def info(self, *args, **kwargs) -> None:  # type: ignore
        self.log(*args, **kwargs)

    def warning(self, *args, **kwargs) -> None:  # type: ignore
        self.log(*args, **kwargs)

    def error(self, *args, **kwargs) -> None:  # type: ignore
        self.log(*args, **kwargs)
        sys.exit(1)

    def log(self, message: str, attributes: Dict[str, str] = {}) -> None:
        self._eprint(self.maybe_prefix(message, attributes))
        self.drain_log_queue()
        self.log_line(message, attributes)

    def log_serial(self, message: str, machine: str) -> None:
        self.enqueue({"msg": message, "machine": machine, "type": "serial"})
        if self._print_serial_logs:
            self._eprint(
                Style.DIM + "{} # {}".format(machine, message) + Style.RESET_ALL
            )

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
    def nested(self, message: str, attributes: Dict[str, str] = {}) -> Iterator[None]:
        self._eprint(
            self.maybe_prefix(
                Style.BRIGHT + Fore.GREEN + message + Style.RESET_ALL, attributes
            )
        )

        self.xml.startElement("nest", attrs={})
        self.xml.startElement("head", attributes)
        self.xml.characters(message)
        self.xml.endElement("head")

        tic = time.time()
        self.drain_log_queue()
        yield
        self.drain_log_queue()
        toc = time.time()
        self.log("(finished: {}, in {:.2f} seconds)".format(message, toc - tic))

        self.xml.endElement("nest")


rootlog = Logger()
