unpackCmdHooks+=(_tryUnpack7zip)

# 7zip supports unpacking many formats.
# No need to implement our own inaccurate extension-based detection.
_tryUnpack7zip() {
  if [[ ! -f "$curSrc" ]] || [[ "$curSrc" == *.tar.* ]]; then
    # Compressed tarballs should use tar instead, and 7zip doesn't
    # recursively unpack. So it would just leave a .tar file in
    # the build directory
    return 1;
  fi
  # Disble stdout, progress, and error messages
  # yes to all
  # ignore NTFS streams
  # extract to symlinks rather than hardlinks
  7zz x -bso0 -bsp0 -bse0 -y -sns- -snld "$curSrc"
}
