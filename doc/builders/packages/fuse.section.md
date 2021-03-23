# FUSE {#sec-fuse}

Some packages rely on
[FUSE](https://www.kernel.org/doc/html/latest/filesystems/fuse.html) to provide
support for additional filesystems not supported by the kernel.

In general, FUSE software are primarily developed for Linux but many of them can
also run on macOS. Nixpkgs supports FUSE packages on macOS, but it requires
[macFUSE](https://osxfuse.github.io) to be installed outside of Nix. macFUSE
currently isn't packaged in Nixpkgs mainly because it includes a kernel
extension, which isn't supported by Nix outside of NixOS.

If a package fails to run on macOS with an error message similar to the
following, it's a likely sign that you need to have macFUSE installed.

    dyld: Library not loaded: /usr/local/lib/libfuse.2.dylib
    Referenced from: /nix/store/w8bi72bssv0bnxhwfw3xr1mvn7myf37x-sshfs-fuse-2.10/bin/sshfs
    Reason: image not found
    [1]    92299 abort      /nix/store/w8bi72bssv0bnxhwfw3xr1mvn7myf37x-sshfs-fuse-2.10/bin/sshfs
