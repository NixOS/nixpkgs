# this file was copied from https://github.com/NixOS/nix and modified to
# add support for marking fetches as __impure derivations.

{ system ? "" # obsolete
, url
, hash ? "" # an SRI hash

# Legacy hash specification
, md5 ? "", sha1 ? "", sha256 ? "", sha512 ? ""
, outputHash ?
    if hash != "" then hash else if sha512 != "" then sha512 else if sha1 != "" then sha1 else if md5 != "" then md5 else sha256
, outputHashAlgo ?
    if hash != "" then "" else if sha512 != "" then "sha512" else if sha1 != "" then "sha1" else if md5 != "" then "md5" else "sha256"

, executable ? false
, unpack ? false
, name ? baseNameOf (toString url)
}:

derivation ({
  builder = "builtin:fetchurl";

  # New-style output content requirements.
  outputHashMode = if unpack || executable then "recursive" else "flat";
  __impure = outputHash=="";

  inherit name url executable unpack;

  system = "builtin";

  # No need to double the amount of network traffic
  preferLocalBuild = true;

  impureEnvVars = [
    # We borrow these environment variables from the caller to allow
    # easy proxy configuration.  This is impure, but a fixed-output
    # derivation like fetchurl is allowed to do so since its result is
    # by definition pure.
    "http_proxy" "https_proxy" "ftp_proxy" "all_proxy" "no_proxy"
  ];

  # To make "nix-prefetch-url" work.
  urls = [ url ];
} // (if outputHash=="" then { } else { inherit outputHashAlgo outputHash; }))
