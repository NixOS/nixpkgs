class MachineError(Exception):
    """
    Exception that indicates an error that is NOT the user's fault,
    i.e. something went wrong without the test being necessarily invalid,
    such as failing OCR.

    To make it easier to spot, this exception (and its subclasses)
    get a `!!!` prefix in the log output.
    """


class RequestedAssertionFailed(AssertionError):
    """
    Special assertion that gets thrown on an assertion error,
    e.g. a failing `t.assertEqual(...)` or `machine.succeed(...)`.

    This gets special treatment in error reporting: i.e. it gets
    `!!!` as prefix just as `MachineError`, but only stack frames coming
    from `testScript` will show up in logs.
    """
