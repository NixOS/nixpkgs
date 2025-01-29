import time
from collections.abc import Callable
from math import isfinite

from test_driver.logger import AbstractLogger


class PollingConditionError(Exception):
    pass


class PollingCondition:
    condition: Callable[[], bool]
    seconds_interval: float
    description: str | None
    logger: AbstractLogger

    last_called: float
    entry_count: int

    def __init__(
        self,
        condition: Callable[[], bool | None],
        logger: AbstractLogger,
        seconds_interval: float = 2.0,
        description: str | None = None,
    ):
        self.condition = condition  # type: ignore
        self.seconds_interval = seconds_interval
        self.logger = logger

        if description is None:
            if condition.__doc__:
                self.description = condition.__doc__
            else:
                self.description = condition.__name__
        else:
            self.description = str(description)

        self.last_called = float("-inf")
        self.entry_count = 0

    def check(self, force: bool = False) -> bool:
        if (self.entered or not self.overdue) and not force:
            return True

        with self, self.logger.nested(self.nested_message):
            time_since_last = time.monotonic() - self.last_called
            last_message = (
                f"Time since last: {time_since_last:.2f}s"
                if isfinite(time_since_last)
                else "(not called yet)"
            )

            self.logger.info(last_message)
            try:
                res = self.condition()  # type: ignore
            except Exception:
                res = False
            res = res is None or res
            self.logger.info(self.status_message(res))
            return res

    def maybe_raise(self) -> None:
        if not self.check():
            raise PollingConditionError(self.status_message(False))

    def status_message(self, status: bool) -> str:
        return f"Polling condition {'succeeded' if status else 'failed'}: {self.description}"

    @property
    def nested_message(self) -> str:
        nested_message = ["Checking polling condition"]
        if self.description is not None:
            nested_message.append(repr(self.description))

        return " ".join(nested_message)

    @property
    def overdue(self) -> bool:
        return self.last_called + self.seconds_interval < time.monotonic()

    @property
    def entered(self) -> bool:
        # entry_count should never dip *below* zero
        assert self.entry_count >= 0
        return self.entry_count > 0

    def __enter__(self) -> None:
        self.entry_count += 1

    def __exit__(self, exc_type, exc_value, traceback) -> None:  # type: ignore
        assert self.entered
        self.entry_count -= 1
        self.last_called = time.monotonic()
