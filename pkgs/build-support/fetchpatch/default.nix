# This function downloads and normalizes a patch/diff file.
# This is primarily useful for dynamically generated patches,
# such as GitHub's or cgit's, where the non-significant content parts
# often change with updating of git or cgit.
# stripLen acts as the -p parameter when applying a patch.

{
  lib,
  fetchurl,
  patchutils,
  modifypatchscript,
}:

{
  relative ? null,
  stripLen ? 0,
  decode ? "cat", # custom command to decode patch e.g. base64 -d
  extraPrefix ? null,
  excludes ? [ ],
  includes ? [ ],
  revert ? false,
  postFetch ? "",
  nativeBuildInputs ? [ ],
  ...
}@args:
fetchurl (
  {
    nativeBuildInputs = [ patchutils ] ++ nativeBuildInputs;
    postFetch = ''
      ${modifypatchscript {
        inherit
          relative
          stripLen
          decode
          extraPrefix
          excludes
          includes
          revert
          ;
      }}
      ${postFetch}
    '';
  }
  // builtins.removeAttrs args [
    "relative"
    "stripLen"
    "decode"
    "extraPrefix"
    "excludes"
    "includes"
    "revert"
    "postFetch"
    "nativeBuildInputs"
  ]
)
