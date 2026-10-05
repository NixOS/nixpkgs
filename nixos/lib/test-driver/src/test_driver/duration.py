import datetime as dt
import warnings

# A duration accepted by the public test-driver API.
# `datetime.timedelta` is the preferred form. Bare `int`/`float` values are still
# accepted for backwards compatibility (interpreted as a number of seconds),
# but doing so is deprecated: use `datetime.timedelta` instead.
Duration = dt.timedelta | int | float


def as_timedelta(duration: Duration) -> dt.timedelta:
    """Coerce a `Duration` into a `datetime.timedelta`.

    Bare numbers are interpreted as seconds. This keeps existing test scripts
    that pass plain integers working while `datetime.timedelta` becomes the preferred
    way to express durations.
    """
    if isinstance(duration, dt.timedelta):
        return duration
    if isinstance(duration, bool):
        raise TypeError(f"expected a duration, got bool: {duration!r}")
    if isinstance(duration, (int, float)):
        return dt.timedelta(seconds=duration)
    raise TypeError(
        f"expected a timedelta, int, or float duration, got {type(duration).__name__}"
    )


def as_seconds(duration: Duration) -> float:
    """Coerce a `Duration` into a floating-point number of seconds."""
    return as_timedelta(duration).total_seconds()


def _warn_if_numeric_duration(duration: Duration | None, func_name: str) -> None:
    """Emit a warning if `duration` is a bare number instead of a `timedelta`."""
    if duration is None or isinstance(duration, bool):
        return
    if isinstance(duration, (int, float)):
        warnings.warn(
            f"{func_name}(): passing a bare int/float as a duration is "
            "deprecated. Use datetime.timedelta instead.",
        )
