# FUSE {#sec-fuse}

Some packages rely on
[FUSE](https://www.kernel.org/doc/html/latest/filesystems/fuse.html) to provide
support for additional filesystems not supported by the kernel.

In general, FUSE software is primarily developed for Linux but many of them can
also run on macOS. Nixpkgs supports FUSE packages on macOS, but it requires
[macFUSE](https://osxfuse.github.io) to be installed outside of Nix. macFUSE
currently isn't packaged in Nixpkgs, mainly because it includes a kernel
extension, which isn't supported by Nix outside of NixOS.

If a package fails to run on macOS with an error message similar to the
following, it's a likely sign that you need to have macFUSE installed.

    dyld: Library not loaded: /usr/local/lib/libfuse.2.dylib
    Referenced from: /nix/store/w8bi72bssv0bnxhwfw3xr1mvn7myf37x-sshfs-fuse-2.10/bin/sshfs
    Reason: image not found
    [1]    92299 abort      /nix/store/w8bi72bssv0bnxhwfw3xr1mvn7myf37x-sshfs-fuse-2.10/bin/sshfs

Package maintainers may often encounter the following error when building FUSE
packages on macOS:

    checking for fuse.h... no
    configure: error: No fuse.h found.

This happens on autoconf-based projects that use `AC_CHECK_HEADERS` or
`AC_CHECK_LIBS` to detect libfuse, and will occur even when the `fuse` package
is included in `buildInputs`. It happens because libfuse headers throw an error
on macOS if the `FUSE_USE_VERSION` macro is undefined. Many projects do define
`FUSE_USE_VERSION`, but only inside C source files. This results in the above
error at configure time because the configure script would attempt to compile
sample FUSE programs without defining `FUSE_USE_VERSION`.

There are two possible solutions for this problem in Nixpkgs:

1. Pass `FUSE_USE_VERSION` to the configure script by adding
   `CFLAGS=-DFUSE_USE_VERSION=25` in `configureFlags`. The actual value would
   have to match the definition used in the upstream source code.
2. Remove `AC_CHECK_HEADERS` / `AC_CHECK_LIBS` for libfuse.

However, a better solution might be to fix the build script upstream to use
`PKG_CHECK_MODULES` instead. This approach wouldn't suffer from the problem that
`AC_CHECK_HEADERS`/`AC_CHECK_LIBS` has at the price of introducing a dependency
on pkg-config.
