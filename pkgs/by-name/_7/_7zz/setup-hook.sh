unpackCmdHooks+=(_tryUnpack7zip)

# 7zip supports unpacking many formats.
# No need to implement our own inaccurate extension-based detection.
_tryUnpack7zip() {
  local mime="$(file -zb --mime-type "$curSrc")"

  if [[ "$mime" == "application/x-tar" ]]; then
    # Compressed tarballs should use tar instead, and 7zip doesn't
    # recursively unpack. So it would just leave a .tar file in
    # the build directory
    return 1
  fi

  local flags=(
    "-bso0" # Disable stdout
    "-bsp0" # Disable progress output
    "-bse0" # Disable stderr output
    "-sns-" # Ignore auxilliary filesystem streams
    # Allow 'dangerous' links, which are links that include '..'
    # This does not include absolute paths and links that escape the archive,
    # those require a higher 'dangerous level'.
    "-snld"
    "-y" # Accept all prompts
  )
  7zz x "${flags[@]}" "$curSrc"
}
