import datetime as dt
import json
import socket
import threading
from collections.abc import Iterator
from queue import Queue
from typing import Any

import pytest

from test_driver.machine.qmp import QMPSession

QMP_GREETING = {
    "QMP": {
        "version": {
            "qemu": {"major": 11, "minor": 1, "micro": 0},
            "package": "",
        },
        "capabilities": [],
    }
}


class QMPServer:
    def __init__(self, sock: socket.socket) -> None:
        self.sock = sock
        self.reader = sock.makefile("r")

    def send(self, message: dict[str, Any]) -> None:
        self.sock.sendall(f"{json.dumps(message)}\n".encode())

    def receive(self) -> dict[str, Any]:
        return json.loads(self.reader.readline())

    def close(self) -> None:
        self.reader.close()
        self.sock.close()


def respond_once(
    server: QMPServer, responses: list[dict[str, Any]]
) -> tuple[threading.Thread, Queue[dict[str, Any]]]:
    requests: Queue[dict[str, Any]] = Queue()

    def respond() -> None:
        requests.put(server.receive())
        for response in responses:
            server.send(response)

    thread = threading.Thread(target=respond)
    thread.start()
    return thread, requests


@pytest.fixture
def qmp_session() -> Iterator[tuple[QMPSession, QMPServer]]:
    client_sock, server_sock = socket.socketpair()
    server = QMPServer(server_sock)
    server.send(QMP_GREETING)
    thread, requests = respond_once(server, [{"return": {}}])
    session = QMPSession(client_sock)

    thread.join(timeout=1)
    assert not thread.is_alive()
    assert requests.get_nowait() == {"execute": "qmp_capabilities"}

    try:
        yield session, server
    finally:
        session.reader.close()
        session.writer.close()
        session.close()
        server.close()


@pytest.mark.usefixtures("qmp_session")
def test_negotiates_qmp_capabilities() -> None:
    pass


def test_sends_command_with_arguments(
    qmp_session: tuple[QMPSession, QMPServer],
) -> None:
    session, server = qmp_session
    thread, requests = respond_once(server, [{"return": {"status": "running"}}])

    result = session.send("query-status", {"verbose": "true"})

    thread.join(timeout=1)
    assert not thread.is_alive()
    assert requests.get_nowait() == {
        "execute": "query-status",
        "arguments": {"verbose": "true"},
    }
    assert result == {"return": {"status": "running"}}


def test_queues_event_received_before_command_result(
    qmp_session: tuple[QMPSession, QMPServer],
) -> None:
    session, server = qmp_session
    event = {"event": "RESET", "data": {"guest": True}}
    thread, _ = respond_once(server, [event, {"return": {}}])

    assert session.send("system_reset") == {"return": {}}

    thread.join(timeout=1)
    assert not thread.is_alive()
    assert list(session.events()) == [event]


def test_reports_connection_closed_before_greeting() -> None:
    client_sock, server_sock = socket.socketpair()
    server_sock.close()

    try:
        with pytest.raises(
            ConnectionError,
            match="QMP connection closed",
        ):
            QMPSession(client_sock)
    finally:
        client_sock.close()


def test_reports_connection_closed_while_waiting_for_result(
    qmp_session: tuple[QMPSession, QMPServer],
) -> None:
    session, server = qmp_session
    requests: Queue[dict[str, Any]] = Queue()

    def disconnect() -> None:
        requests.put(server.receive())
        server.close()

    thread = threading.Thread(target=disconnect)
    thread.start()

    with pytest.raises(
        ConnectionError,
        match="QMP connection closed",
    ):
        session.send("query-status")

    thread.join(timeout=1)
    assert not thread.is_alive()
    assert requests.get_nowait() == {"execute": "query-status"}


def test_reports_connection_closed_while_waiting_for_event(
    qmp_session: tuple[QMPSession, QMPServer],
) -> None:
    session, server = qmp_session
    errors: Queue[BaseException] = Queue()

    def wait_for_event() -> None:
        try:
            session.wait_for_event()
        except BaseException as error:
            errors.put(error)

    server.close()
    thread = threading.Thread(target=wait_for_event, daemon=True)
    thread.start()
    thread.join(timeout=1)

    assert not thread.is_alive(), "wait_for_event did not detect the disconnect"
    assert isinstance(errors.get_nowait(), ConnectionError)


def test_waiting_for_event_times_out(
    qmp_session: tuple[QMPSession, QMPServer],
) -> None:
    session, _ = qmp_session

    with pytest.raises(TimeoutError):
        session.wait_for_event(dt.timedelta(milliseconds=10))
