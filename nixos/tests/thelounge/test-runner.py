import aiohttp
import asyncio
import json
import sys


async def main():
    public = True if sys.argv[1] == "true" else False
    hasThemes = True if sys.argv[2] == "true" else False
    user = None
    password = None

    if len(sys.argv) == 5:
        user = sys.argv[3]
        password = sys.argv[4]

    async with aiohttp.ClientSession() as session:
        async with session.ws_connect(
            "http://localhost:9000/socket.io/?EIO=4&transport=websocket"
        ) as ws:
            async for msg in ws:
                if msg.type == aiohttp.WSMsgType.TEXT:
                    typ = msg.data[0]
                    data = msg.data[1:]

                    # engine.io protocol (ref: https://github.com/socketio/engine.io-protocol)
                    if typ == "2":
                        # Ping, reply with pong.
                        await ws.send_str("3")
                    elif typ == "0":
                        # Send an engine.io message containing a socket.io CONNECT packet.
                        await ws.send_str("40")
                    elif typ == "4":
                        # A message from the server.
                        typ = data[0]
                        data = data[1:]

                        # socket.io protocol (ref: https://github.com/socketio/socket.io-protocol)
                        if typ == "2":
                            # An event.
                            data = json.loads(data)
                            event = data[0]
                            payload = None

                            if len(data) > 1:
                                payload = data[1]

                            if event == "configuration":
                                assert payload["public"] is public

                                if hasThemes:
                                    assert any(
                                        [
                                            theme["name"] == "thelounge-theme-solarized"
                                            for theme in payload["themes"]
                                        ]
                                    )

                                await ws.send_str("42" + json.dumps(["changelog"]))
                            elif event == "auth:start":
                                payload = [
                                    "auth:perform",
                                    {"user": user, "password": password},
                                ]
                                await ws.send_str("42" + json.dumps(payload))
                            elif event == "auth:failed":
                                raise Exception("authentication failed")
                            elif event == "changelog":
                                assert payload["packages"] is False

                                break


asyncio.run(main())
