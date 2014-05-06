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

  auto-detected-patch = with stdenv.lib; url:
    let url2 = removePrefix "http://" (removePrefix "https://" url);
    in  ( hasPrefix "github.com" url2
          && (hasSuffix ".diff" url2 || hasSuffix ".patch" url2)
        ) || (
          hasPrefix "cgit." url2
          && ("patch" == (builtins.elemAt (reverseList (splitString "/" url2)) 1))
                        #^ next-to-last part of the URL is "/patch/"
        );

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

, # If set, don't download the file, but write a list of all possible
  # URLs (resulting from resolving mirror:// URLs) to $out.
  showURLs ? false

  # set for patches to clean useless changing parts, true for github and cgit url
, cleanPatch ? (auto-detected-patch url)
}:

assert builtins.isList urls;
assert urls != [] -> url == "";
assert url != "" -> urls == [];

assert showURLs || (outputHash != "" && outputHashAlgo != "")
    || md5 != "" || sha1 != "" || sha256 != "";

let

  urls_ = if urls != [] then urls else [url];

in

stdenv.mkDerivation {
  name =
    if showURLs then "urls"
    else if name != "" then name
    else baseNameOf (toString (builtins.head urls_));

  builder = ./builder.sh;

  buildInputs = [curl];

  urls = urls_;

  # If set, prefer the content-addressable mirrors
  # (http://tarballs.nixos.org) over the original URLs.
  preferHashedMirrors = true;

  # New-style output content requirements.
  outputHashAlgo = if outputHashAlgo != "" then outputHashAlgo else
      if sha256 != "" then "sha256" else if sha1 != "" then "sha1" else "md5";
  outputHash = if outputHash != "" then outputHash else
      if sha256 != "" then sha256 else if sha1 != "" then sha1 else md5;

  inherit curlOpts showURLs mirrorsFile impureEnvVars;

  # Doing the download on a remote machine just duplicates network
  # traffic, so don't do that.
  preferLocalBuild = true;

  # The following sed commands are a bit crazy, I know
  maybeCleanPatch = stdenv.lib.optionalString cleanPatch ''
    echo "Cleaning the patch"
    sed -e '/^[^-+ @]/d; 0,/^---[ \t]/s/^[^-].*//; /^--[- ]\?$/d; /^$/d' \
      -e 's/^\(@@[^@]*@@\).*$/\1/; s/^\(\(---\|+++\) [^ \t]*\).*$/\1/' \
      -i "$out"
  '';
}
