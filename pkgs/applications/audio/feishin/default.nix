{ lib
, stdenv
, callPackage
, ...
}@args:

let
  extraArgs = removeAttrs args [ "callPackage" ];

  pname = "feishin";
  version = "0.3.0";
  appname = "Feishin";

  meta = with lib; {
    description = "Full-featured Subsonic/Jellyfin compatible desktop music player";
    homepage = "https://github.com/jeffvli/feishin";
    changelog = "https://github.com/jeffvli/feishin/releases/tag/v${version}";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.mit;
    platforms = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
    maintainers = with maintainers; [ onny ];
  };

in if stdenv.isDarwin
then callPackage ./darwin.nix (extraArgs // { inherit pname appname version meta; })
else callPackage ./linux.nix (extraArgs // { inherit pname appname version meta; })
