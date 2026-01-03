#!/usr/bin/env python3

import os
import sys
import shutil

def main():
    prefix = os.environ.get('MESON_INSTALL_DESTDIR_PREFIX')
    assert prefix, 'MESON_INSTALL_DESTDIR_PREFIX not set'

    libdir = os.path.join(prefix, 'lib')
    pkgconfigdir = os.path.join(libdir, 'pkgconfig')

    if os.path.exists(os.path.join(libdir, "libsystre.dll.a")):
        shutil.copy2(
            os.path.join(libdir, "libsystre.dll.a"),
            os.path.join(libdir, "libgnurx.dll.a")
        )
        shutil.copy2(
            os.path.join(libdir, "libsystre.dll.a"),
            os.path.join(libdir, "libregex.dll.a")
        )

    if os.path.exists(os.path.join(libdir, "libsystre.a")):
        shutil.copy2(
            os.path.join(libdir, "libsystre.a"),
            os.path.join(libdir, "libgnurx.a")
        )
        shutil.copy2(
            os.path.join(libdir, "libsystre.a"),
            os.path.join(libdir, "libregex.a")
        )

    if os.path.exists(os.path.join(pkgconfigdir, "regex.pc")):
        shutil.copy2(
            os.path.join(pkgconfigdir, "regex.pc"),
            os.path.join(pkgconfigdir, "gnurx.pc")
        )

    return 0

if __name__ == "__main__":
    sys.exit(main())


