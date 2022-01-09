from subprocess import check_call
from contextlib import contextmanager
from pathlib import Path

exampleDir = Path("/tmp/exampleDir")
exampleDir.mkdir(parents=True, exist_ok=True)

exampleFile = exampleDir / "exampleFile"
exampleFile.write_bytes(bytes(range(256)))
assert exampleFile.exists()


def host_files_same(path1, path2):
    return check_call(["diff", path1, path2])


@contextmanager
def must_raise(exception_text, exception_class=Exception):
    try:
        yield
    except exception_class as e:
        if exception_text in str(e):
            return
    raise Exception(f"Expected exception {repr(exception_text)}")


@contextmanager
def no_sleep():
    import time

    old_sleep = time.sleep
    time.sleep = lambda x: None
    yield
    time.sleep = old_sleep


start_all()
