{stdenv, curl, writeScript}: # Note that `curl' may be `null', in case of the native stdenv.

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
  sites =
    if builtins ? attrNames
    then builtins.attrNames mirrors
    else [] /* backwards compatibility */;

in

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

, # If set, down't download file but tell user how to download it.
  restricted ? false

, # Used only if restricted. Should contain instructions how to fetch the file.
  message ? ""
}:

assert urls != [] -> url == "";
assert url != "" -> urls == [];

assert showURLs || (outputHash != "" && outputHashAlgo != "")
    || md5 != "" || sha1 != "" || sha256 != "";

let

  urls_ = if urls != [] then urls else [url];
  name_ = if showURLs then "urls"
    else if name != "" then name
    else baseNameOf (toString (builtins.head urls_));
  hashAlgo_ = if outputHashAlgo != "" then outputHashAlgo else
    if sha256 != "" then "sha256" else if sha1 != "" then "sha1" else "md5";
  hash_ = if outputHash != "" then outputHash else
    if sha256 != "" then sha256 else if sha1 != "" then sha1 else md5;
in

stdenv.mkDerivation ({
  name = name_;
  outputHashAlgo = hashAlgo_;
  outputHash = hash_;
  urls = urls_;

  # Compatibility with Nix <= 0.7.
  id = md5;

  inherit showURLs mirrorsFile;
}
// (if (!showURLs && restricted) then rec {
  builder = writeScript "restrict-message" ''
source ${stdenv}/setup
cat <<_EOF_
${message_}
_EOF_
  '';
  message_ = if message != "" then message else ''
  You have to download ${name_} from ${stdenv.lib.concatStringsSep " " urls_} yourself,
  and add it to the store using "nix-store --add-fixed ${hashAlgo_} ${name_}".
  '';
}
else {
  builder = ./builder.sh;

  buildInputs = [curl];


  # If set, prefer the content-addressable mirrors
  # (http://nixos.org/tarballs) over the original URLs.
  preferHashedMirrors = true;


  # New-style output content requirements.

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
})
)