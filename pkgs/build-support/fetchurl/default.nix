{ stdenv, curl }: # Note that `curl' may be `null', in case of the native stdenv.

let

  mirrors = import ./mirrors.nix;

  # Write the list of mirrors to a file that we can reuse between
  # fetchurl instantiations, instead of passing the mirrors to
  # fetchurl instantiations via environment variables.  This makes the
  # resulting store derivations (.drv files) much smaller, which in
  # turn makes nix-env/nix-instantiate faster.
  mirrorsFile =
    stdenv.mkDerivation ({
      name = "mirrors-list";
      builder = ./write-mirror-list.sh;
      preferLocalBuild = true;
    } // mirrors);

  # Names of the master sites that are mirrored (i.e., "sourceforge",
  # "gnu", etc.).
  sites = builtins.attrNames mirrors;

  impureEnvVars = [
    # We borrow these environment variables from the caller to allow
    # easy proxy configuration.  This is impure, but a fixed-output
    # derivation like fetchurl is allowed to do so since its result is
    # by definition pure.
    "http_proxy" "https_proxy" "ftp_proxy" "all_proxy" "no_proxy"

    # This variable allows the user to pass additional options to curl
    "NIX_CURL_FLAGS"

    # This variable allows the user to override hashedMirrors from the
    # command-line.
    "NIX_HASHED_MIRRORS"

    # This variable allows overriding the timeout for connecting to
    # the hashed mirrors.
    "NIX_CONNECT_TIMEOUT"
  ] ++ (map (site: "NIX_MIRRORS_${site}") sites);

in

{ # URL to fetch.
  url ? ""

, # Alternatively, a list of URLs specifying alternative download
  # locations.  They are tried in order.
  urls ? []

, # Additional curl options needed for the download to succeed.
  curlOpts ? ""

, # Name of the file.  If empty, use the basename of `url' (or of the
  # first element of `urls').
  name ? ""

  # Different ways of specifying the hash.
, outputHash ? ""
, outputHashAlgo ? ""
, md5 ? ""
, sha1 ? ""
, sha256 ? ""
, sha512 ? ""

, recursiveHash ? false

, # Shell code executed after the file has been fetched
  # successfully. This can do things like check or transform the file.
  postFetch ? ""

, # Whether to download to a temporary path rather than $out. Useful
  # in conjunction with postFetch. The location of the temporary file
  # is communicated to postFetch via $downloadedFile.
  downloadToTemp ? false

, # If true, set executable bit on downloaded file
  executable ? false

, # If set, don't download the file, but write a list of all possible
  # URLs (resulting from resolving mirror:// URLs) to $out.
  showURLs ? false

, # Meta information, if any.
  meta ? {}
}:

assert builtins.isList urls;
assert (urls == []) != (url == "");


let

  hasHash = showURLs || (outputHash != "" && outputHashAlgo != "")
    || md5 != "" || sha1 != "" || sha256 != "" || sha512 != "";
  urls_ = if urls != [] then urls else [url];

in

if (!hasHash) then throw "Specify hash for fetchurl fixed-output derivation: ${stdenv.lib.concatStringsSep ", " urls_}" else stdenv.mkDerivation {
  name =
    if showURLs then "urls"
    else if name != "" then name
    else baseNameOf (toString (builtins.head urls_));

  builder = ./builder.sh;

  buildInputs = [ curl ];

  urls = urls_;

  # If set, prefer the content-addressable mirrors
  # (http://tarballs.nixos.org) over the original URLs.
  preferHashedMirrors = true;

  # New-style output content requirements.
  outputHashAlgo = if outputHashAlgo != "" then outputHashAlgo else
      if sha512 != "" then "sha512" else if sha256 != "" then "sha256" else if sha1 != "" then "sha1" else "md5";
  outputHash = if outputHash != "" then outputHash else
      if sha512 != "" then sha512 else if sha256 != "" then sha256 else if sha1 != "" then sha1 else md5;

  outputHashMode = if (recursiveHash || executable) then "recursive" else "flat";

  inherit curlOpts showURLs mirrorsFile impureEnvVars postFetch downloadToTemp executable;

  # Doing the download on a remote machine just duplicates network
  # traffic, so don't do that.
  preferLocalBuild = true;

  inherit meta;
}
