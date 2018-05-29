{ system, stdenvNoCC, lib, fetchurlCurl }:
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

, # Shell code to build a netrc file for BASIC auth
  netrcPhase ? null

, # Impure env vars (http://nixos.org/nix/manual/#sec-advanced-attributes)
  # needed for netrcPhase
  netrcImpureEnvVars ? []

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

  # Passthru information, if any.
, passthru ? {}
} @ args:
# Fallback to fetchurlCurl when arguments are used that are not supported by the Nix-builtin fetchurl.
if curlOpts != ""
|| netrcPhase != null
|| postFetch != ""
|| downloadToTemp
|| showURLs
|| urls != []
|| (lib.strings.hasPrefix "mirror:" url)
then
  fetchurlCurl args
else
let
  hash_ =
    if md5 != "" then throw "fetchurl does not support md5 anymore, please use sha256 or sha512"
    else if (outputHash != "" && outputHashAlgo != "") then { inherit outputHashAlgo outputHash; }
    else if sha512 != "" then { outputHashAlgo = "sha512"; outputHash = sha512; }
    else if sha256 != "" then { outputHashAlgo = "sha256"; outputHash = sha256; }
    else if sha1   != "" then { outputHashAlgo = "sha1";   outputHash = sha1; }
    else throw "fetchurl requires a hash for fixed-output derivation: ${url}";
  name_ = let
      components = lib.strings.splitString "/" url;
      filenameWithQuery = lib.last components;
      firstComponent = sep: str: builtins.head (lib.strings.splitString sep str);
      filename = firstComponent "&" (firstComponent "?" filenameWithQuery);
    in filename;
in
stdenvNoCC.mkDerivation {
  realBuilder = "builtin:fetchurl";
  preferLocalBuild = true;
  impureEnvVars = [
    # We borrow these environment variables from the caller to allow
    # easy proxy configuration.  This is impure, but a fixed-output
    # derivation like fetchurl is allowed to do so since its result is
    # by definition pure.
    "http_proxy" "https_proxy" "ftp_proxy" "all_proxy" "no_proxy"
  ];
  inherit
    system
    url
    executable;
  inherit (hash_) outputHashAlgo outputHash;
  outputHashMode = if (recursiveHash || executable) then "recursive" else "flat";
  urls = [ url ];
  name = name_;

  inherit meta;
  inherit passthru;
}
