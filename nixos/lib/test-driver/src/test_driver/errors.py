class TestScriptError(Exception):
    """
    The base error class to indicate that the test script failed.
    This (and its subclasses) get special treatment, i.e. only stack
    frames from `testScript` are printed and the error gets prefixed
    with `!!!` to make it easier to spot between other log-lines.

    This class is used for errors that aren't an actual test failure,
    but also not a bug in the driver, e.g. failing OCR.
    """


class RequestedAssertionFailed(TestScriptError):
    """
    Subclass of `TestScriptError` that gets special treatment.

    Exception raised when a requested assertion fails,
    e.g. `machine.succeed(...)` or `t.assertEqual(...)`.

    This is separate from the base error class, to have a dedicated class name
    that better represents this kind of failures.
    (better readability in test output)
    """
