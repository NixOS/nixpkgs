{ system ? builtins.currentSystem }:

let
  inherit (import <nixpkgs> {}) lib writeText;

  sources = if builtins.pathExists ./sources.nix
            then import ./sources.nix
            else null;

  bucketURL = "http://commondatastorage.googleapis.com/"
            + "chromium-browser-official";

  tryChannel = channel: let
    chanAttrs = builtins.getAttr channel sources;
  in if sources != null then ''
    oldver="${chanAttrs.version}";
    echo -n "Checking if $oldver ($channel) is up to date..." >&2;
    if [ "x$(get_newest_ver "$version" "$oldver")" != "x$oldver" ];
    then
      echo " no, getting sha256 for new version $version:" >&2;
      sha256="$(nix-prefetch-url "$url")" || return 1;
    else
      echo " yes, keeping old sha256." >&2;
      sha256="${chanAttrs.sha256}";
    fi;
  '' else ''
    sha256="$(nix-prefetch-url "$url")" || return 1;
  '';

  caseChannel = channel: ''
    ${channel}) ${tryChannel channel};;
  '';

in rec {
  getChannel = channel: let
    chanAttrs = builtins.getAttr channel sources;
  in {
    url = "${bucketURL}/chromium-${chanAttrs.version}.tar.xz";
    inherit (chanAttrs) version sha256;
  };

  updateHelpers = writeText "update-helpers.sh" ''
    get_sha256()
    {
      channel="$1";
      version="$2";
      url="${bucketURL}/chromium-$version.tar.xz";

      case "$channel" in
        ${lib.concatMapStrings caseChannel [ "stable" "dev" "beta" ]}
      esac;

      sha_insert "$version" "$sha256";
      echo "$sha256";
      return 0;
    }
  '';
}
