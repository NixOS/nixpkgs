from typing import Callable, Optional, Any, List, Dict
from functools import wraps

import time

from .logger import rootlog


class PollingConditionFailed(Exception):
    pass


def coopmulti(fun: Callable, *, machine: Any = None) -> Callable:
    assert not (fun is None and machine is None)

    def inner(fun_: Callable) -> Any:
        @wraps(fun_)
        def wrapper(*args: List[Any], **kwargs: Dict[str, Any]) -> Any:
            this_machine = args[0] if machine is None else machine

            if this_machine.fail_early():  # type: ignore
                raise PollingConditionFailed("Action interrupted early...")

            return fun_(*args, **kwargs)

        return wrapper

    if fun is None:
        return inner
    else:
        return inner(fun)


class PollingCondition:
    condition: Callable[[], bool]
    seconds_interval: float
    description: Optional[str]

    last_called: float
    entered: bool

    def __init__(
        self,
        condition: Callable[[], Optional[bool]],
        seconds_interval: float = 2.0,
        description: Optional[str] = None,
    ):
        self.condition = condition  # type: ignore
        self.seconds_interval = seconds_interval

        if description is None:
            self.description = condition.__doc__
        else:
            self.description = str(description)

        self.last_called = float("-inf")
        self.entered = False

    def check(self) -> bool:
        if self.entered or not self.overdue:
            return True

        with self, rootlog.nested(self.nested_message):
            rootlog.info(f"Time since last: {time.monotonic() - self.last_called:.2f}s")
            try:
                res = self.condition()  # type: ignore
            except Exception:
                res = False
            res = res is None or res
            rootlog.info(f"Polling condition {'succeeded' if res else 'failed'}")
            return res

    @property
    def nested_message(self) -> str:
        nested_message = ["Checking polling condition"]
        if self.description is not None:
            nested_message.append(repr(self.description))

        return " ".join(nested_message)

    @property
    def overdue(self) -> bool:
        return self.last_called + self.seconds_interval < time.monotonic()

    def __enter__(self) -> None:
        self.entered = True

    def __exit__(self, exc_type, exc_value, traceback) -> None:  # type: ignore
        self.entered = False
        self.last_called = time.monotonic()
