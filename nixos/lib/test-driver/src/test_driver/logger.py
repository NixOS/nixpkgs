import logging
import sys
import time
from abc import ABC, abstractmethod
from collections.abc import Iterator
from contextlib import contextmanager
from enum import IntEnum
from typing import Any

from colorama import Fore, Style

LOG_LEVEL_MAP = {
    1: logging.INFO,
    2: logging.WARNING,
    3: logging.ERROR,
}


class LogLevel(IntEnum):
    INFO = 1
    WARNING = 2
    ERROR = 3


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

    @abstractmethod
    def set_log_level(self, level: LogLevel) -> None:
        pass


class Logger(AbstractLogger):
    def __init__(self) -> None:
        self._logger = logging.getLogger("test_driver")
        self._logger.setLevel(logging.INFO)
        self._logger.propagate = False

        if not self._logger.handlers:
            handler = logging.StreamHandler(sys.stderr)
            handler.setFormatter(logging.Formatter("%(message)s"))
            self._logger.addHandler(handler)

        self._print_serial_logs = True

    @staticmethod
    def _maybe_prefix(message: str, attributes: dict[str, str]) -> str:
        if "machine" in attributes:
            return f"{attributes['machine']}: {message}"
        return message

    def log(self, message: str, attributes: dict[str, str] = {}) -> None:
        # log() always prints regardless of log level
        print(self._maybe_prefix(message, attributes), file=sys.stderr)

    @contextmanager
    def subtest(self, name: str, attributes: dict[str, str] = {}) -> Iterator[None]:
        with self.nested("subtest: " + name, attributes):
            yield

    @contextmanager
    def nested(self, message: str, attributes: dict[str, str] = {}) -> Iterator[None]:
        print(
            self._maybe_prefix(
                Style.BRIGHT + Fore.GREEN + message + Style.RESET_ALL, attributes
            ),
            file=sys.stderr,
        )

        tic = time.time()
        yield
        toc = time.time()
        self.log(f"(finished: {message}, in {toc - tic:.2f} seconds)", attributes)

    def info(self, *args: Any, **kwargs: Any) -> None:
        message = args[0] if args else ""
        attributes = args[1] if len(args) > 1 else {}
        self._logger.info(self._maybe_prefix(message, attributes))

    def warning(self, *args: Any, **kwargs: Any) -> None:
        message = args[0] if args else ""
        attributes = args[1] if len(args) > 1 else {}
        self._logger.warning(self._maybe_prefix(message, attributes))

    def error(self, *args: Any, **kwargs: Any) -> None:
        message = args[0] if args else ""
        attributes = args[1] if len(args) > 1 else {}
        self._logger.error(self._maybe_prefix(message, attributes))
        sys.exit(1)

    def log_test_error(self, *args: Any, **kwargs: Any) -> None:
        prefix = Fore.RED + "!!! " + Style.RESET_ALL
        # NOTE: using _logger.error directly instead of self.error() to avoid sys.exit(1)
        self._logger.error(f"{prefix}{args[0]}")

    def log_serial(self, message: str, machine: str) -> None:
        if not self._print_serial_logs:
            return

        print(Style.DIM + f"{machine} # {message}" + Style.RESET_ALL, file=sys.stderr)

    def print_serial_logs(self, enable: bool) -> None:
        self._print_serial_logs = enable

    def set_log_level(self, level: LogLevel) -> None:
        self._logger.setLevel(LOG_LEVEL_MAP[level])
