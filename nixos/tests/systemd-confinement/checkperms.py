import errno
import os

from enum import IntEnum
from pathlib import Path


class Accessibility(IntEnum):
    """
    The level of accessibility we have on a file or directory.

    This is needed to assess the attack surface on the file system namespace we
    have within a confined service. Higher levels mean more permissions for the
    user and thus a bigger attack surface.
    """
    NONE = 0

    # Directories can be listed or files can be read.
    READABLE = 1

    # This is for special file systems such as procfs and for stuff such as
    # FIFOs or character special files. The reason why this has a lower value
    # than WRITABLE is because those files are more restricted on what and how
    # they can be written to.
    SPECIAL = 2

    # Another special case are sticky directories, which do allow write access
    # but restrict deletion. This does *not* apply to sticky directories that
    # are read-only.
    STICKY = 3

    # Essentially full permissions, the kind of accessibility we want to avoid
    # in most cases.
    WRITABLE = 4

    def assert_on(self, path: Path) -> None:
        """
        Raise an AssertionError if the given 'path' allows for more
        accessibility than 'self'.
        """
        actual = self.NONE

        if path.is_symlink():
            actual = self.READABLE
        elif path.is_dir():
            writable = True

            dummy_file = path / 'can_i_write'
            try:
                dummy_file.touch()
            except OSError as e:
                if e.errno in [errno.EROFS, errno.EACCES]:
                    writable = False
                else:
                    raise
            else:
                dummy_file.unlink()

            if writable:
                # The reason why we test this *after* we made sure it's
                # writable is because we could have a sticky directory where
                # the current user doesn't have write access.
                if path.stat().st_mode & 0o1000 == 0o1000:
                    actual = self.STICKY
                else:
                    actual = self.WRITABLE
            else:
                actual = self.READABLE
        elif path.is_file():
            try:
                with path.open('rb') as fp:
                    fp.read(1)
                actual = self.READABLE
            except PermissionError:
                pass

            writable = True
            try:
                with path.open('ab') as fp:
                    fp.write('x')
                    size = fp.tell()
                    fp.truncate(size)
            except PermissionError:
                writable = False
            except OSError as e:
                if e.errno == errno.ETXTBSY:
                    writable = os.access(path, os.W_OK)
                elif e.errno == errno.EROFS:
                    writable = False
                else:
                    raise

            # Let's always try to fail towards being writable, so if *either*
            # access(2) or a real write is successful it's writable. This is to
            # make sure we don't accidentally introduce no-ops if we have bugs
            # in the more complicated real write code above.
            if writable or os.access(path, os.W_OK):
                actual = self.WRITABLE
        else:
            # We need to be very careful when writing to or reading from
            # special files (eg.  FIFOs), since they can possibly block. So if
            # it's not a file, just trust that access(2) won't lie.
            if os.access(path, os.R_OK):
                actual = self.READABLE

            if os.access(path, os.W_OK):
                actual = self.SPECIAL

        if actual > self:
            stat = path.stat()
            details = ', '.join([
                f'permissions: {stat.st_mode & 0o7777:o}',
                f'uid: {stat.st_uid}',
                f'group: {stat.st_gid}',
            ])

            raise AssertionError(
                f'Expected at most {self!r} but got {actual!r} for path'
                f' {path} ({details}).'
            )


def is_special_fs(path: Path) -> bool:
    """
    Check whether the given path truly is a special file system such as procfs
    or sysfs.
    """
    try:
        if path == Path('/proc'):
            return (path / 'version').read_text().startswith('Linux')
        elif path == Path('/sys'):
            return b'Linux' in (path / 'kernel' / 'notes').read_bytes()
    except FileNotFoundError:
        pass
    return False


def is_empty_dir(path: Path) -> bool:
    try:
        next(path.iterdir())
        return False
    except (StopIteration, PermissionError):
        return True


def _assert_permissions_in_directory(
    directory: Path,
    accessibility: Accessibility,
    subdirs: dict[Path, Accessibility],
) -> None:
    accessibility.assert_on(directory)

    for file in directory.iterdir():
        if is_special_fs(file):
            msg = f'Got unexpected special filesystem at {file}.'
            assert subdirs.pop(file) == Accessibility.SPECIAL, msg
        elif not file.is_symlink() and file.is_dir():
            subdir_access = subdirs.pop(file, accessibility)
            if is_empty_dir(file):
                # Whenever we got an empty directory, we check the permission
                # constraints on the current directory (except if specified
                # explicitly in subdirs) because for example if we're non-root
                # (the constraints of the current directory are thus
                # Accessibility.READABLE), we really have to make sure that
                # empty directories are *never* writable.
                subdir_access.assert_on(file)
            else:
                _assert_permissions_in_directory(file, subdir_access, subdirs)
        else:
            subdirs.pop(file, accessibility).assert_on(file)


def assert_permissions(subdirs: dict[str, Accessibility]) -> None:
    """
    Recursively check whether the file system conforms to the accessibility
    specification we specified via 'subdirs'.
    """
    root = Path('/')
    absolute_subdirs = {root / p: a for p, a in subdirs.items()}
    _assert_permissions_in_directory(
        root,
        Accessibility.WRITABLE if os.getuid() == 0 else Accessibility.READABLE,
        absolute_subdirs,
    )
    for file in absolute_subdirs.keys():
        msg = f'Expected {file} to exist, but it was nowwhere to be found.'
        raise AssertionError(msg)
