import contextlib
import os
import tempfile
import typing
from pathlib import Path

from nixos_rebuild.tmpdir import MAX_TMPDIR_LENGTH, make_tmpdir


@contextlib.contextmanager
def tempfile_tempdir(path: str) -> typing.Generator[None]:
    Path(path).mkdir(exist_ok=True)
    og_tmpdir = tempfile.tempdir
    try:
        tempfile.tempdir = path
        assert tempfile.gettempdir() == path
        yield
    finally:
        tempfile.tempdir = og_tmpdir


def test_make_tmpdir() -> None:
    def assert_tmpdir(tmp: Path) -> None:
        assert tmp.exists()
        assert tmp.is_dir()
        assert len(os.fsencode(str(tmp))) <= MAX_TMPDIR_LENGTH

    # Basic test: whatever the default system temp dir happens to be.
    tmpdir = make_tmpdir()
    tmp = Path(tmpdir.name)

    assert_tmpdir(tmp)

    # Test with a short system temp dir. We should use it unmodified.
    short_tempdir = "/tmp/not-too-long"
    with tempfile_tempdir(short_tempdir):
        tmpdir = make_tmpdir()
        tmp = Path(tmpdir.name)

        assert tmp.parent == Path(short_tempdir)
        assert_tmpdir(tmp)

    # Test with a long system temp dir. We should ignore
    # it and fall back to something short enough for OpenSSH to
    # create sockets in.
    with tempfile_tempdir("/tmp/long" + ("g" * MAX_TMPDIR_LENGTH)):
        tmpdir = make_tmpdir()
        tmp = Path(tmpdir.name)

        assert_tmpdir(tmp)
