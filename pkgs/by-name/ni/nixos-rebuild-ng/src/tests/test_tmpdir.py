import contextlib
import os
import tempfile
import typing
from pathlib import Path

from nixos_rebuild.tmpdir import MAX_TMPDIR_LENGTH, make_tmpdir


@contextlib.contextmanager
def tempfile_tempdir(path: str) -> typing.Generator[None]:
    Path(path).mkdir(exist_ok=True)
    try:
        og_tmpdir = tempfile.tempdir
        tempfile.tempdir = path
        assert tempfile.gettempdir() == path
        yield
    finally:
        tempfile.tempdir = og_tmpdir


def test_make_tmpdir() -> None:
    # Basic test: whatever the default system temp dir happens to be.
    tmpdir = make_tmpdir()
    tmp = Path(tmpdir.name)
    assert tmp.exists()
    assert tmp.is_dir()
    assert len(os.fsencode(str(tmp))) <= MAX_TMPDIR_LENGTH

    # Test with a short system temp dir. We should use it unmodified.
    with tempfile_tempdir("/tmp/not-too-long"):
        tmpdir = make_tmpdir()
        tmp = Path(tmpdir.name)

        assert tmp.exists()
        assert tmp.is_dir()
        assert len(os.fsencode(str(tmp))) <= MAX_TMPDIR_LENGTH

    # Test with a long system temp dir. We should ignore
    # it and fall back to something short enough for OpenSSH to
    # create sockets in.
    with tempfile_tempdir("/tmp/long" + ("g" * MAX_TMPDIR_LENGTH)):
        tmpdir = make_tmpdir()
        tmp = Path(tmpdir.name)

        assert tmp.exists()
        assert tmp.is_dir()
        assert len(os.fsencode(str(tmp))) <= MAX_TMPDIR_LENGTH
