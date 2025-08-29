{
  callPackage,
  fetchurl,
  lib,
  stdenvNoCC,
}:

let
  inherit (stdenvNoCC.hostPlatform) system;

  pname = "slack";

  x86_64-darwin-version = "4.45.64";
  x86_64-darwin-sha256 = "0skhh16lc0czxd5ifkqy39hibk4ydlfhn41zdif3hl0sd4vcqbvb";

  x86_64-linux-version = "4.45.64";
  x86_64-linux-sha256 = "7c6af86ab1d5778aec930d4e7d77b9f9948a83a87e8458e821d6f9e8dfed180f";

  aarch64-darwin-version = "4.45.64";
  aarch64-darwin-sha256 = "136crd17ybaznp680qb2rl0c8cllkkv21ymf3dck2jhkqbp7v2kj";

  sources =
    let
      base = "https://downloads.slack-edge.com";
    in
    {
      x86_64-darwin = rec {
        version = x86_64-darwin-version;
        src = fetchurl {
          url = "${base}/desktop-releases/mac/universal/${version}/Slack-${version}-macOS.dmg";
          sha256 = x86_64-darwin-sha256;
        };
      };
      x86_64-linux = rec {
        version = x86_64-linux-version;
        src = fetchurl {
          url = "${base}/desktop-releases/linux/x64/${version}/slack-desktop-${version}-amd64.deb";
          sha256 = x86_64-linux-sha256;
        };
      };
      aarch64-darwin = rec {
        version = aarch64-darwin-version;
        src = fetchurl {
          url = "${base}/desktop-releases/mac/arm64/${version}/Slack-${version}-macOS.dmg";
          sha256 = aarch64-darwin-sha256;
        };
      };
    };

  passthru = {
    updateScript = ./update.sh;
  };

  meta = {
    description = "Desktop client for Slack";
    homepage = "https://slack.com";
    changelog = "https://slack.com/release-notes";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [
      mmahut
      prince213
      teutat3s
    ];
    platforms = [
      "x86_64-darwin"
      "x86_64-linux"
      "aarch64-darwin"
    ];
    mainProgram = "slack";
  };
in
callPackage (if stdenvNoCC.hostPlatform.isDarwin then ./darwin.nix else ./linux.nix) {
  inherit pname passthru meta;
  inherit (sources.${system} or (throw "Unsupported system: ${system}")) version src;
}
