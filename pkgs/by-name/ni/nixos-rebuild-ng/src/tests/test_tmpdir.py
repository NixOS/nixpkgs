import contextlib
import os
import tempfile
import typing
from pathlib import Path

from nixos_rebuild.tmpdir import MAX_TMPDIR_LENGTH, make_tmpdir


@contextlib.contextmanager
def system_tempdir(path: Path) -> typing.Generator[None]:
    path.mkdir(exist_ok=True)

    # `tempfile` caches the tempdir, you must clear it for it to recompute.
    tempfile.tempdir = None

    og_tmpdir = os.environ.get("TMPDIR")

    try:
        os.environ["TMPDIR"] = str(path)
        assert Path(tempfile.gettempdir()) == path
        yield
    finally:
        if og_tmpdir is None:
            del os.environ["TMPDIR"]
        else:
            os.environ["TMPDIR"] = og_tmpdir


def test_make_tmpdir() -> None:
    # Basic test: whatever the default system temp dir happens to be.
    tmpdir = make_tmpdir()
    tmp = Path(tmpdir.name)
    assert tmp.exists()
    assert tmp.is_dir()
    assert len(os.fsencode(str(tmp))) <= MAX_TMPDIR_LENGTH

    # Test with a short system temp dir. We should use it unmodified.
    with system_tempdir(Path("/tmp/not-too-long")):
        tmpdir = make_tmpdir()
        tmp = Path(tmpdir.name)

        assert tmp.exists()
        assert tmp.is_dir()
        assert len(os.fsencode(str(tmp))) <= MAX_TMPDIR_LENGTH

    # Test with a long system temp dir. We should ignore
    # it and fall back to something short enough for OpenSSH to
    # create sockets in.
    with system_tempdir(Path("/tmp/long" + ("g" * MAX_TMPDIR_LENGTH))):
        tmpdir = make_tmpdir()
        tmp = Path(tmpdir.name)

        assert tmp.exists()
        assert tmp.is_dir()
        assert len(os.fsencode(str(tmp))) <= MAX_TMPDIR_LENGTH
