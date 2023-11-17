import json
import logging
import os
import socket
from collections.abc import Iterator
from pathlib import Path
from queue import Queue
from typing import Any

logger = logging.getLogger(__name__)


class QMPAPIError(RuntimeError):
    def __init__(self, message: dict[str, Any]):
        assert "error" in message, "Not an error message!"
        try:
            self.class_name = message["class"]
            self.description = message["desc"]
            # NOTE: Some errors can occur before the Server is able to read the
            # id member; in these cases the id member will not be part of the
            # error response, even if provided by the client.
            self.transaction_id = message.get("id")
        except KeyError:
            raise RuntimeError("Malformed QMP API error response")

    def __str__(self) -> str:
        return f"<QMP API error related to transaction {self.transaction_id} [{self.class_name}]: {self.description}>"


class QMPSession:
    def __init__(self, sock: socket.socket) -> None:
        self.sock = sock
        self.results: Queue[dict[str, str]] = Queue()
        self.pending_events: Queue[dict[str, Any]] = Queue()
        self.reader = sock.makefile("r")
        self.writer = sock.makefile("w")
        # Make the reader non-blocking so we can kind of select on it.
        os.set_blocking(self.reader.fileno(), False)
        hello = self._wait_for_new_result()
        logger.debug(f"Got greeting from QMP API: {hello}")
        # The greeting message format is:
        # { "QMP": { "version": json-object, "capabilities": json-array } }
        assert "QMP" in hello, f"Unexpected result: {hello}"
        self.send("qmp_capabilities")

    @classmethod
    def from_path(cls, path: Path) -> "QMPSession":
        sock = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
        sock.connect(str(path))
        return cls(sock)

    def __del__(self) -> None:
        self.sock.close()

    def _wait_for_new_result(self) -> dict[str, str]:
        assert self.results.empty(), "Results set is not empty, missed results!"
        while self.results.empty():
            self.read_pending_messages()
        return self.results.get()

    def read_pending_messages(self) -> None:
        line = self.reader.readline()
        if not line:
            return
        evt_or_result = json.loads(line)
        logger.debug(f"Received a message: {evt_or_result}")

        # It's a result
        if "return" in evt_or_result or "QMP" in evt_or_result:
            self.results.put(evt_or_result)
        # It's an event
        elif "event" in evt_or_result:
            self.pending_events.put(evt_or_result)
        else:
            raise QMPAPIError(evt_or_result)

    def wait_for_event(self, timeout: int = 10) -> dict[str, Any]:
        while self.pending_events.empty():
            self.read_pending_messages()

        return self.pending_events.get(timeout=timeout)

    def events(self, timeout: int = 10) -> Iterator[dict[str, Any]]:
        while not self.pending_events.empty():
            yield self.pending_events.get(timeout=timeout)

    def send(self, cmd: str, args: dict[str, str] = {}) -> dict[str, str]:
        self.read_pending_messages()
        assert self.results.empty(), "Results set is not empty, missed results!"
        data: dict[str, Any] = dict(execute=cmd)
        if args != {}:
            data["arguments"] = args

        logger.debug(f"Sending {data} to QMP...")
        json.dump(data, self.writer)
        self.writer.write("\n")
        self.writer.flush()
        return self._wait_for_new_result()
