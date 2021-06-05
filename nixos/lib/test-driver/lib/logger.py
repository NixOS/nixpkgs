"""The Logger domain knows how to present test output to users
or machines (for automated parsing)
"""
from typing import Iterator, Dict, Any
import contextlib
import logging

from pythonjsonlogger import jsonlogger


@contextlib.contextmanager
def nested(
    logger: logging.Logger, header: str, attrs: Dict[str, Any] = {}
) -> Iterator[None]:
    yield


class JsonFormatter(jsonlogger.JsonFormatter):
    # TODO: implement nested logging as before
    pass


# from contextlib import contextmanager
# from typing import Tuple, Dict, Iterator
# from queue import Queue, Empty
# from xml.sax.saxutils import XMLGenerator
# import codecs
# import os
# import time
# import unicodedata

# def sanitise(message: str) -> str:
#     return "".join(ch for ch in message if unicodedata.category(ch)[0] != "C")


# class XmlLogger(Logger):
#     def __init__(self) -> None:
#         Logger.__init__(self)

#         self.logfile = os.environ.get("LOGFILE")
#         if self.logfile is None:
#             raise Exception("Using XmlLogger, but LOGFILE env variable not defined")
#         self.logfile_handle = codecs.open(self.logfile, "wb")
#         self.xml = XMLGenerator(self.logfile_handle, encoding="utf-8")
#         self.queue: "Queue[Tuple[str,Dict[str, str]]]" = Queue()

#         self.xml.startDocument()
#         self.xml.startElement("logfile", attrs={})

#     def release(self) -> None:
#         self.xml.endElement("logfile")
#         self.xml.endDocument()
#         self.logfile_handle.close()

#     def _log_line(self, message: str, attributes: Dict[str, str]) -> None:
#         self.xml.startElement("line", attributes)
#         self.xml.characters(message)
#         self.xml.endElement("line")

#     def log_machinestate(self, message: str, attributes: Dict[str, str] = {}) -> None:
#         self._drain_log_queue()
#         self._log_line(message, attributes)

#     def log_serial(self, message: str, attributes: Dict[str, str] = {}) -> None:
#         self._enqueue((message, {"type": "serial"}))

#     def _enqueue(self, message: Tuple[str, Dict[str, str]]) -> None:
#         self.queue.put(message)

#     def _drain_log_queue(self) -> None:
#         try:
#             while True:
#                 item = self.queue.get_nowait()
#                 (msg, attributes) = item
#                 self._log_line(sanitise(msg), attributes)
#         except Empty:
#             pass

#     @contextmanager
#     def nested(self, message: str, attributes: Dict[str, str] = {}) -> Iterator[None]:

#         self.xml.startElement("nest", attrs={})
#         self.xml.startElement("head", attributes)
#         self.xml.characters(message)
#         self.xml.endElement("head")

#         tic = time.time()
#         self._drain_log_queue()
#         yield
#         self._drain_log_queue()
#         toc = time.time()
#         self.log_machinestate(f"({(toc-tic):.2f} seconds)")

#         self.xml.endElement("nest")
