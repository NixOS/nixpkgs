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

, # If set, don't download the file, but write a list of all possible
  # URLs (resulting from resolving mirror:// URLs) to $out.
  showURLs ? false
}:

assert urls != [] -> url == "";
assert url != "" -> urls == [];

assert showURLs || (outputHash != "" && outputHashAlgo != "")
    || md5 != "" || sha1 != "" || sha256 != "";

let

  urls_ = if urls != [] then urls else [url];

  mirrors = import ./mirrors.nix;

  # Names of the master sites that are mirrored (i.e., "sourceforge",
  # "gnu", etc.).
  sites =
    if builtins ? attrNames
    then builtins.attrNames mirrors
    else [] /* backwards compatibility */;
  
in

stdenv.mkDerivation ({
  name =
    if showURLs then "urls"
    else if name != "" then name
    else baseNameOf (toString (builtins.head urls_));
  builder = ./builder.sh;
  buildInputs = [curl];

  urls = urls_;

  # If set, prefer the content-addressable mirrors
  # (http://nix.cs.uu.nl/dist/tarballs) over the original URLs.
  preferHashedMirrors = true;

  # Compatibility with Nix <= 0.7.
  id = md5;

  # New-style output content requirements.
  outputHashAlgo = if outputHashAlgo != "" then outputHashAlgo else
      if sha256 != "" then "sha256" else if sha1 != "" then "sha1" else "md5";
  outputHash = if outputHash != "" then outputHash else
      if sha256 != "" then sha256 else if sha1 != "" then sha1 else md5;
  
  impureEnvVars = [
    # We borrow these environment variables from the caller to allow
    # easy proxy configuration.  This is impure, but a fixed-output
    # derivation like fetchurl is allowed to do so since its result is
    # by definition pure.
    "http_proxy" "https_proxy" "ftp_proxy" "all_proxy" "no_proxy"

    # This variable allows the user to override hashedMirrors from the
    # command-line.
    "NIX_HASHED_MIRRORS"
  ] ++ (map (site: "NIX_MIRRORS_${site}") sites);

  inherit showURLs;
}

# Pass the mirror locations to the builder.
// mirrors

)
