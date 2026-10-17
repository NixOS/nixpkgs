import datetime as dt
import time
import warnings
from collections.abc import Callable
from math import isfinite

from test_driver.duration import as_timedelta
from test_driver.logger import AbstractLogger


class PollingConditionError(Exception):
    pass


class PollingCondition:
    condition: Callable[[], bool]
    interval: dt.timedelta
    description: str | None
    logger: AbstractLogger

    last_called: float
    entry_count: int

    def __init__(
        self,
        condition: Callable[[], bool | None],
        logger: AbstractLogger,
        seconds_interval: float | None = None,
        description: str | None = None,
        *,
        interval: dt.timedelta | None = None,
    ):
        if seconds_interval is not None:
            if interval is not None:
                raise TypeError(
                    "PollingCondition() got both 'interval' and 'seconds_interval' arguments. Pass only 'interval'"
                )
            warnings.warn(
                "PollingCondition(): The 'seconds_interval' argument is deprecated. Use 'interval' instead.",
            )
            interval = as_timedelta(seconds_interval)

        self.condition = condition  # ty: ignore[invalid-assignment]
        self.interval = interval if interval is not None else dt.timedelta(seconds=2)
        self.logger = logger

        if description is None:
            if condition.__doc__:
                self.description = condition.__doc__
            else:
                self.description = condition.__name__  # ty: ignore[unresolved-attribute]
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
                res = self.condition()
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
        if not isfinite(self.last_called):
            # `last_called` is `-inf` until the condition has run at least once.
            return True
        time_since_last = dt.timedelta(seconds=time.monotonic() - self.last_called)
        return time_since_last > self.interval

    @property
    def entered(self) -> bool:
        # entry_count should never dip *below* zero
        assert self.entry_count >= 0
        return self.entry_count > 0

    def __enter__(self) -> None:
        self.entry_count += 1

    def __exit__(self, exc_type, exc_value, traceback) -> None:
        assert self.entered
        self.entry_count -= 1
        self.last_called = time.monotonic()
