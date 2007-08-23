# Argh, this thing is duplicated (more-or-less) in Nix (in corepkgs).
# Need to find a way to combine them.

{stdenv, curl}: # Note that `curl' may be `null', in case of the native stdenv.

{ # URL to fetch.
  url ? ""

, # Alternatively, a list of URLs specifying alternative download
  # locations.  They are tried in order.
  urls ? []

, # Name of the file.  If empty, use the basename of `url' (or of the
  # first element of `urls').
  name ? ""

  # Different ways of specifying the hash.
, outputHash ? ""
, outputHashAlgo ? ""
, md5 ? ""
, sha1 ? ""
, sha256 ? ""
}:

assert urls != [] -> url == "";
assert url != "" -> urls == [];

assert (outputHash != "" && outputHashAlgo != "")
    || md5 != "" || sha1 != "" || sha256 != "";

let urls_ = if urls != [] then urls else [url]; in

stdenv.mkDerivation {
  name =
    if name != "" then name
    else baseNameOf (toString (builtins.head urls_));
  builder = ./builder.sh;
  buildInputs = [curl];

  urls = urls_;

  # The content-addressable mirrors.
  hashedMirrors = [
    http://nix.cs.uu.nl/dist/tarballs
  ];

  # Compatibility with Nix <= 0.7.
  id = md5;

  # New-style output content requirements.
  outputHashAlgo = if outputHashAlgo != "" then outputHashAlgo else
      if sha256 != "" then "sha256" else if sha1 != "" then "sha1" else "md5";
  outputHash = if outputHash != "" then outputHash else
      if sha256 != "" then sha256 else if sha1 != "" then sha1 else md5;
  
  # We borrow these environment variables from the caller to allow
  # easy proxy configuration.  This is impure, but a fixed-output
  # derivation like fetchurl is allowed to do so since its result is
  # by definition pure.
  impureEnvVars = ["http_proxy" "https_proxy" "ftp_proxy" "all_proxy" "no_proxy"];
}
