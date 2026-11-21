import asyncio
import os
import socket
from pathlib import Path

from dbus_next import Message, MessageType, Variant
from dbus_next.aio import MessageBus


class PortalBackend:
    def __init__(self, socket_path: Path):
        self.socket_path = socket_path
        self.sockets: list[socket.socket] = []
        self.calls: list[str] = []
        self.sessions: set[str] = set()

    def handle_message(self, message: Message) -> Message | None:
        if message.message_type != MessageType.METHOD_CALL:
            return None

        if message.interface == "org.freedesktop.DBus.Properties":
            properties = {}
            if message.body[0] == "org.freedesktop.impl.portal.RemoteDesktop":
                properties = {
                    "version": Variant("u", 2),
                    "AvailableDeviceTypes": Variant("u", 1),
                }
            if message.member == "GetAll":
                return Message.new_method_return(message, "a{sv}", [properties])
            if message.member == "Get":
                return Message.new_method_return(
                    message, "v", [properties[message.body[1]]]
                )
            return None

        if message.interface == "org.freedesktop.impl.portal.Session":
            assert message.path in self.sessions
            if message.member == "Close":
                return Message.new_method_return(message)
            return None

        if message.interface != "org.freedesktop.impl.portal.RemoteDesktop":
            return None

        self.calls.append(message.member)
        match message.member:
            case "CreateSession":
                self.sessions.add(message.body[1])
                return Message.new_method_return(message, "ua{sv}", [0, {}])
            case "SelectDevices":
                assert message.body[1] in self.sessions
                assert message.body[3]["types"].value == 1
                return Message.new_method_return(message, "ua{sv}", [0, {}])
            case "Start":
                assert message.body[1] in self.sessions
                return Message.new_method_return(
                    message, "ua{sv}", [0, {"devices": Variant("u", 1)}]
                )
            case "ConnectToEIS":
                assert message.body[0] in self.sessions
                connection = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
                connection.connect(str(self.socket_path))
                self.sockets.append(connection)
                return Message.new_method_return(
                    message, "h", [0], unix_fds=[connection.fileno()]
                )
        return None

    async def __aenter__(self):
        portals = Path("portals").absolute()
        portals.mkdir()
        (portals / "test.portal").write_text(
            "[portal]\n"
            "DBusName=org.freedesktop.impl.portal.Test\n"
            "Interfaces=org.freedesktop.impl.portal.RemoteDesktop;\n"
        )
        (portals / "test-portals.conf").write_text("[preferred]\ndefault=test;\n")
        os.environ["XDG_DESKTOP_PORTAL_DIR"] = str(portals)
        os.environ["XDG_CURRENT_DESKTOP"] = "test"

        self.bus = await MessageBus(negotiate_unix_fd=True).connect()
        self.bus.add_message_handler(self.handle_message)
        await self.bus.request_name("org.freedesktop.impl.portal.Test")
        return self

    async def wait_for_portal(self):
        while True:
            reply = await self.bus.call(
                Message(
                    destination="org.freedesktop.portal.Desktop",
                    path="/org/freedesktop/portal/desktop",
                    interface="org.freedesktop.DBus.Properties",
                    member="Get",
                    signature="ss",
                    body=["org.freedesktop.portal.RemoteDesktop", "version"],
                )
            )
            if reply.message_type == MessageType.METHOD_RETURN:
                assert reply.body[0].value >= 2
                return
            await asyncio.sleep(0.05)

    async def __aexit__(self, exc_type, exc_value, traceback):
        for connection in self.sockets:
            connection.close()
        self.bus.disconnect()
        await self.bus.wait_for_disconnect()
        if exc_type is None:
            assert self.calls == [
                "CreateSession",
                "SelectDevices",
                "Start",
                "ConnectToEIS",
            ]
