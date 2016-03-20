{ system ? builtins.currentSystem }:

let
  inherit (import ../../../../../. {
    inherit system;
  }) lib fetchurl writeText stdenv;

  sources = if builtins.pathExists ./upstream-info.nix
            then import ./upstream-info.nix
            else null;

  bucketURL = "https://commondatastorage.googleapis.com/"
            + "chromium-browser-official";

  debURL = "https://dl.google.com/linux/chrome/deb/pool/main/g";

  # Untrusted mirrors, don't try to update from them!
  debMirrors = [
    "http://95.31.35.30/chrome/pool/main/g"
    "http://mirror.pcbeta.com/google/chrome/deb/pool/main/g"
    "http://repo.fdzh.org/chrome/deb/pool/main/g"
  ];

  tryChannel = channel: let
    chan = builtins.getAttr channel sources;
  in if sources != null then ''
    oldver="${chan.version}";
    echo -n "Checking if $oldver ($channel) is up to date..." >&2;
    if [ "x$(get_newest_ver "$version" "$oldver")" != "x$oldver" ];
    then
      echo " no, getting sha256 for new version $version:" >&2;
      sha256="$(prefetch_sha "$channel" "$version")" || return 1;
    else
      echo " yes, keeping old sha256." >&2;
      sha256="${chan.sha256}";
      ${if (chan ? sha256bin32 && chan ? sha256bin64) then ''
        sha256="$sha256.${chan.sha256bin32}.${chan.sha256bin64}";
      '' else ''
        sha256="$sha256.$(prefetch_deb_sha "$channel" "$version")";
      ''}
    fi;
  '' else ''
    sha256="$(prefetch_sha "$channel" "$version")" || return 1;
  '';

  caseChannel = channel: ''
    ${channel}) ${tryChannel channel};;
  '';

in rec {
  getChannel = channel: let
    chanAttrs = builtins.getAttr channel sources;
  in {
    inherit channel;
    inherit (chanAttrs) version;

    main = fetchurl {
      url = "${bucketURL}/chromium-${chanAttrs.version}.tar.xz";
      inherit (chanAttrs) sha256;
    };

    binary = fetchurl (let
      pname = if channel == "dev"
              then "google-chrome-unstable"
              else "google-chrome-${channel}";
      arch = if stdenv.is64bit then "amd64" else "i386";
      relpath = "${pname}/${pname}_${chanAttrs.version}-1_${arch}.deb";
    in lib.optionalAttrs (chanAttrs ? sha256bin64) {
      urls = map (url: "${url}/${relpath}") ([ debURL ] ++ debMirrors);
      sha256 = if stdenv.is64bit
               then chanAttrs.sha256bin64
               else chanAttrs.sha256bin32;
    });
  };

  updateHelpers = writeText "update-helpers.sh" ''

    prefetch_main_sha()
    {
      nix-prefetch-url "${bucketURL}/chromium-$2.tar.xz";
    }

    prefetch_deb_sha()
    {
      channel="$1";
      version="$2";

      case "$1" in
        dev) pname="google-chrome-unstable";;
        *)   pname="google-chrome-$channel";;
      esac;

      deb_pre="${debURL}/$pname/$pname";

      deb32=$(nix-prefetch-url "''${deb_pre}_$version-1_i386.deb");
      deb64=$(nix-prefetch-url "''${deb_pre}_$version-1_amd64.deb");

      echo "$deb32.$deb64";
      return 0;
    }

    prefetch_sha()
    {
      main_sha="$(prefetch_main_sha "$@")" || return 1;
      deb_sha="$(prefetch_deb_sha "$@")" || return 1;
      echo "$main_sha.$deb_sha";
      return 0;
    }

    get_sha256()
    {
      channel="$1";
      version="$2";

      case "$channel" in
        ${lib.concatMapStrings caseChannel [ "stable" "dev" "beta" ]}
      esac;

      sha_insert "$version" "$sha256";
      echo "$sha256";
      return 0;
    }
  '';
}
