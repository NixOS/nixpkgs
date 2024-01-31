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
        assert logger.rootlog.sanitise("foobar") == "foobar"

        # Remove all non-printable characters
        assert all(
            c in string.printable
            for c in map(chr, range(128))
            if c == logger.rootlog.sanitise(c)
        )

with subtest("must_raise"):
    with subtest("success"), must_raise("Oops."):
        raise Exception("Oops.")

    with subtest("failures"):
        with must_raise("string .* did not match"):
            with must_raise("Something"):
                raise Exception("Another thing")

        with must_raise(".* is not an instance of .*"):
            with must_raise("Oops.", ValueError):
                raise IndexError("Oops.")

        with must_raise("no exception was raised"):
            with must_raise("Oops."):
                pass
