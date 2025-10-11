# This function downloads and unpacks a Darwin disk image.
# This is primarily useful for binary applications distributed as
# a dmg file.

{
  fetchzip,
  _7zz,
}:

{
  nativeBuildInputs ? [ ],
  ...
}@args:

fetchzip (
  args
  // {
    nativeBuildInputs = [ _7zz ] ++ nativeBuildInputs;

    # Exclude */Applications files from extraction as they may
    # contain a dangerous link path, causing 7zz to error.
    # Exclude *com.apple.provenance xattr files from extraction
    # as they may break an application's signature and notarization.
    unpackCmd = ''
      7zz x -bd -xr'!*/Applications' -xr'!*com.apple.provenance' "$curSrc"
    '';
  }
)
