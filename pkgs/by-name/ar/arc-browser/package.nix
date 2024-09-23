{ lib
, stdenvNoCC
, fetchurl
, undmg
, writeShellApplication
, curl
, common-updater-scripts
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "arc-browser";
  version = "1.61.0-53949";

  src = fetchurl {
    url = "https://releases.arc.net/release/Arc-${finalAttrs.version}.dmg";
    hash = "sha256-FuRWi4+vPt31bd3muMDEn3Fu20h9oWEd1XuPJU7W1OU=";
  };

  nativeBuildInputs = [ undmg ];

  sourceRoot = "Arc.app";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications/Arc.app
    cp -R . $out/Applications/Arc.app

    runHook postInstall
  '';

  dontFixup = true;

  passthru.updateScript = lib.getExe (writeShellApplication {
    name = "arc-browser-update-script";
    runtimeInputs = [ curl common-updater-scripts ];
    text = ''
      set -euo pipefail
      redirect_url="$(curl -s -L -f "https://releases.arc.net/release/Arc-latest.dmg" -o /dev/null -w '%{url_effective}')"
      # The url scheme is: https://releases.arc.net/release/Arc-1.23.4-56789.dmg
      # We strip everything before 'Arc-' and after '.dmg'
      version="''${redirect_url##*/Arc-}"
      version="''${version%.dmg}"
      update-source-version arc-browser "$version" --file=./pkgs/by-name/ar/arc-browser/package.nix
    '';
  });

  meta = {
    description = "Arc from The Browser Company";
    homepage = "https://arc.net/";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ donteatoreo ];
    platforms = [ "aarch64-darwin" "x86_64-darwin" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
