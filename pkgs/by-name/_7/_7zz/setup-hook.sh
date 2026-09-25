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
  7zz x -sns- -snld "$curSrc"
}
