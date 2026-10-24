unpackCmdHooks+=(_tryDpkgDeb)
_tryDpkgDeb() {
    # Don't use dpkg-deb -x as that will error if the archive contains a file
    # or directory with a setuid bit in its permissions. This is because dpkg
    # calls tar internally with the -p flag, preserving file permissions.
    #
    # We instead only use dpkg-deb to extract the tarfile containing the files
    # we want from the .deb, then finish extracting with tar directly.
    mkdir root
    dpkg-deb --fsys-tarfile "$curSrc" | tar --extract --directory=root || {
      rmdir root
      return 1
    }
}
