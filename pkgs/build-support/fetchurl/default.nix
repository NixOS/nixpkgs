{
  lib,
  buildPackages ? {
    inherit stdenvNoCC;
  },
  stdenvNoCC,
  curl, # Note that `curl' may be `null', in case of the native stdenvNoCC.
  cacert ? null,
  rewriteURL,
  hashedMirrors,
}:

let

  mirrors = import ./mirrors.nix // {
    inherit hashedMirrors;
  };

  # Write the list of mirrors to a file that we can reuse between
  # fetchurl instantiations, instead of passing the mirrors to
  # fetchurl instantiations via environment variables.  This makes the
  # resulting store derivations (.drv files) much smaller, which in
  # turn makes nix-env/nix-instantiate faster.
  mirrorsFile = buildPackages.stdenvNoCC.mkDerivation (
    {
      name = "mirrors-list";
      strictDeps = true;
      builder = ./write-mirror-list.sh;
      preferLocalBuild = true;
    }
    // mirrors
  );

  # Names of the master sites that are mirrored (i.e., "sourceforge",
  # "gnu", etc.).
  sites = builtins.attrNames mirrors;

  impureEnvVars =
    lib.fetchers.proxyImpureEnvVars
    ++ [
      # This variable allows the user to pass additional options to curl
      "NIX_CURL_FLAGS"

      # This variable allows the user to override hashedMirrors from the
      # command-line.
      "NIX_HASHED_MIRRORS"

      # This variable allows overriding the timeout for connecting to
      # the hashed mirrors.
      "NIX_CONNECT_TIMEOUT"
    ]
    ++ (map (site: "NIX_MIRRORS_${site}") sites);

in

{
  # URL to fetch.
  url ? "",

  # Alternatively, a list of URLs specifying alternative download
  # locations.  They are tried in order.
  urls ? [ ],

  # Additional curl options needed for the download to succeed.
  # Warning: Each space (no matter the escaping) will start a new argument.
  # If you wish to pass arguments with spaces, use `curlOptsList`
  curlOpts ? "",

  # Additional curl options needed for the download to succeed.
  curlOptsList ? [ ],

  # Name of the file.  If empty, use the basename of `url' (or of the
  # first element of `urls').
  name ? "",

  # for versioned downloads optionally take pname + version.
  pname ? "",
  version ? "",

  # SRI hash.
  hash ? "",

  # Legacy ways of specifying the hash.
  outputHash ? "",
  outputHashAlgo ? "",
  sha1 ? "",
  sha256 ? "",
  sha512 ? "",

  recursiveHash ? false,

  # Shell code to build a netrc file for BASIC auth
  netrcPhase ? null,

  # Impure env vars (https://nixos.org/nix/manual/#sec-advanced-attributes)
  # needed for netrcPhase
  netrcImpureEnvVars ? [ ],

  # Shell code executed after the file has been fetched
  # successfully. This can do things like check or transform the file.
  postFetch ? "",

  # Whether to download to a temporary path rather than $out. Useful
  # in conjunction with postFetch. The location of the temporary file
  # is communicated to postFetch via $downloadedFile.
  downloadToTemp ? false,

  # If true, set executable bit on downloaded file
  executable ? false,

  # If set, don't download the file, but write a list of all possible
  # URLs (resulting from resolving mirror:// URLs) to $out.
  showURLs ? false,

  # Meta information, if any.
  meta ? { },

  # Passthru information, if any.
  passthru ? { },
  # Doing the download on a remote machine just duplicates network
  # traffic, so don't do that by default
  preferLocalBuild ? true,

  # Additional packages needed as part of a fetch
  nativeBuildInputs ? [ ],
}@args:

let
  preRewriteUrls =
    if urls != [ ] && url == "" then
      (
        if lib.isList urls then urls else throw "`urls` is not a list: ${lib.generators.toPretty { } urls}"
      )
    else if urls == [ ] && url != "" then
      (
        if lib.isString url then
          [ url ]
        else
          throw "`url` is not a string: ${lib.generators.toPretty { } urls}"
      )
    else
      throw "fetchurl requires either `url` or `urls` to be set: ${lib.generators.toPretty { } args}";

  urls_ =
    let
      u = lib.lists.filter (url: lib.isString url) (map rewriteURL preRewriteUrls);
    in
    if u == [ ] then throw "urls is empty after rewriteURL (was ${toString preRewriteUrls})" else u;

  hash_ =
    if
      with lib.lists;
      length (
        filter (s: s != "") [
          hash
          outputHash
          sha1
          sha256
          sha512
        ]
      ) > 1
    then
      throw "multiple hashes passed to fetchurl: ${lib.generators.toPretty { } urls_}"
    else

    if hash != "" then
      {
        outputHashAlgo = null;
        outputHash = hash;
      }
    else if outputHash != "" then
      if outputHashAlgo != "" then
        { inherit outputHashAlgo outputHash; }
      else
        throw "fetchurl was passed outputHash without outputHashAlgo: ${lib.generators.toPretty { } urls_}"
    else if sha512 != "" then
      {
        outputHashAlgo = "sha512";
        outputHash = sha512;
      }
    else if sha256 != "" then
      {
        outputHashAlgo = "sha256";
        outputHash = sha256;
      }
    else if sha1 != "" then
      {
        outputHashAlgo = "sha1";
        outputHash = sha1;
      }
    else if cacert != null then
      {
        outputHashAlgo = "sha256";
        outputHash = "";
      }
    else
      throw "fetchurl requires a hash for fixed-output derivation: ${lib.generators.toPretty { } urls_}";

  resolvedUrl =
    let
      mirrorSplit = lib.match "mirror://([[:alpha:]]+)/(.+)" url;
      mirrorName = lib.head mirrorSplit;
      mirrorList =
        if lib.hasAttr mirrorName mirrors then
          mirrors."${mirrorName}"
        else
          throw "unknown mirror:// site ${mirrorName}";
    in
    if mirrorSplit == null || mirrorName == null then
      url
    else
      "${lib.head mirrorList}${lib.elemAt mirrorSplit 1}";
in

assert
  (lib.isList curlOpts)
  -> lib.warn ''
    fetchurl for ${toString (builtins.head urls_)}: curlOpts is a list (${
      lib.generators.toPretty { multiline = false; } curlOpts
    }), which is not supported anymore.
    - If you wish to get the same effect as before, for elements with spaces (even if escaped) to expand to multiple curl arguments, use a string argument instead:
      curlOpts = ${lib.strings.escapeNixString (toString curlOpts)};
    - If you wish for each list element to be passed as a separate curl argument, allowing arguments to contain spaces, use curlOptsList instead:
      curlOptsList = [ ${lib.concatMapStringsSep " " lib.strings.escapeNixString curlOpts} ];'' true;

stdenvNoCC.mkDerivation (
  (
    if (pname != "" && version != "") then
      { inherit pname version; }
    else
      {
        name =
          if showURLs then
            "urls"
          else if name != "" then
            name
          else
            baseNameOf (toString (builtins.head urls_));
      }
  )
  // {
    builder = ./builder.sh;

    nativeBuildInputs = [ curl ] ++ nativeBuildInputs;

    urls = urls_;

    # If set, prefer the content-addressable mirrors
    # (http://tarballs.nixos.org) over the original URLs.
    preferHashedMirrors = false;

    # New-style output content requirements.
    inherit (hash_) outputHashAlgo outputHash;

    # Disable TLS verification only when we know the hash and no credentials are
    # needed to access the resource
    SSL_CERT_FILE =
      if
        (
          hash_.outputHash == ""
          || hash_.outputHash == lib.fakeSha256
          || hash_.outputHash == lib.fakeSha512
          || hash_.outputHash == lib.fakeHash
          || netrcPhase != null
        )
      then
        "${cacert}/etc/ssl/certs/ca-bundle.crt"
      else
        "/no-cert-file.crt";

    outputHashMode = if (recursiveHash || executable) then "recursive" else "flat";

    inherit curlOpts;
    curlOptsList = lib.escapeShellArgs curlOptsList;
    inherit
      showURLs
      mirrorsFile
      postFetch
      downloadToTemp
      executable
      ;

    impureEnvVars = impureEnvVars ++ netrcImpureEnvVars;

    nixpkgsVersion = lib.trivial.release;

    inherit preferLocalBuild;

    postHook =
      if netrcPhase == null then
        null
      else
        ''
          ${netrcPhase}
          curlOpts="$curlOpts --netrc-file $PWD/netrc"
        '';

    inherit meta;
    passthru = {
      inherit url resolvedUrl;
    }
    // passthru;
  }
)
