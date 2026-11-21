import errno
import logging
import logging.handlers
import os
import sys
import threading

from icmp_tunnel import MTU, Server, Client


def main():
    import argparse

    logger = logging.getLogger(__name__)

    parser = argparse.ArgumentParser(description="ICMP Tunnel - Server/Client")
    parser.add_argument("mode", choices=["server", "client"], help="Run mode: server or client")
    parser.add_argument("--mtu", type=int, default=MTU, help=f"MTU size (default: {MTU})")
    parser.add_argument("--dst", type=str, help="Destination IP (required for client mode)")
    parser.add_argument("--iface", type=str, help="Network interface (default: eth0)")
    parser.add_argument("--verbose", "-v", action="store_true", help="Enable verbose logging")

    args = parser.parse_args()

    if args.verbose:
        for handler in logging.getLogger().handlers:
            if isinstance(handler, logging.StreamHandler) and not isinstance(
                handler, logging.handlers.RotatingFileHandler
            ):
                handler.setLevel(logging.DEBUG)

    def receive_messages(tunnel, stop_event):
        stdout_fd = sys.stdout.fileno()

        while not stop_event.is_set():
            try:
                for received_data in tunnel.recv():
                    if not received_data:
                        continue

                    try:
                        os.write(stdout_fd, received_data)
                    except OSError as e:
                        if e.errno == errno.EPIPE:
                            stop_event.set()
                            return
                        stop_event.set()
                        return

            except Exception as e:
                logger.error("tunnel.recv() error: %s", e)
                return

    def read_stdin_bytes():
        try:
            data = os.read(0, 1024)
            if not data:
                return None
            return data
        except KeyboardInterrupt:
            return None

    try:
        if args.mode == "server":
            if args.dst:
                parser.error("--dst is not used in server mode")

            if not args.iface:
                parser.error("--iface must be set in server mode")

            logger.info("Starting server on interface %s with MTU=%s...", args.iface, args.mtu)
            server = Server(iface=args.iface, mtu=args.mtu)
            server.start()
            logger.info("Server started on interface %s with MTU=%s", args.iface, args.mtu)

            stop_event = threading.Event()
            receive_thread = threading.Thread(
                target=receive_messages, args=(server, stop_event), daemon=True
            )
            receive_thread.start()

            try:
                while True:
                    message = read_stdin_bytes()
                    if message:
                        server.send(message)
            except KeyboardInterrupt:
                logger.info("Stopping server...")
                stop_event.set()
                server.stop()

        elif args.mode == "client":
            if not args.dst:
                parser.error("--dst is required for client mode")

            client = Client(dst=args.dst, mtu=args.mtu)
            client.start()
            logger.info("Client started, connecting to %s with MTU=%s", args.dst, args.mtu)

            stop_event = threading.Event()
            receive_thread = threading.Thread(
                target=receive_messages, args=(client, stop_event), daemon=True
            )
            receive_thread.start()

            try:
                while True:
                    message = read_stdin_bytes()
                    if message:
                        client.send(message)
            except KeyboardInterrupt:
                logger.info("Stopping client...")
                stop_event.set()
                client.stop()

    except Exception as e:
        logger.error("Error: %s", e)
        sys.exit(1)


if __name__ == "__main__":
    main()
