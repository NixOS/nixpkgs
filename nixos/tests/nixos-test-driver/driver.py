# Basically everything that doesn't need a machine object to work.

from test_driver import logger
import string

with subtest("subtest"):
    with must_raise("", SystemExit):
        # Logger.error uses sys.exit. TODO: is this what we want?
        with subtest("foobar"):
            raise Exception("Oops.")

with subtest("Logger"):
    with subtest("sanitise"):
        # No-op when no special characters are present
        assert logger.sanitise("foobar") == "foobar"

        # Remove all non-printable characters
        assert all(
            chr(c) in string.printable
            for c in range(128)
            if chr(c) == logger.sanitise(chr(c))
        )
