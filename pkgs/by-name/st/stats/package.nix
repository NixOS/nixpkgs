{ lib
, stdenvNoCC
, fetchurl
, undmg
, writeShellApplication
, curl
, jq
, common-updater-scripts
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "stats";
  version = "2.10.10";

  src = fetchurl {
    url = "https://github.com/exelban/stats/releases/download/v${finalAttrs.version}/Stats.dmg";
    hash = "sha256-CdTY5Qv/xF9ItNgHQFqec5nKObnImx/+MuFShTfdrAo=";
  };

  sourceRoot = ".";

  nativeBuildInputs = [ undmg ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    cp -r *.app $out/Applications

    runHook postInstall
  '';

  passthru.updateScript = lib.getExe (writeShellApplication {
    name = "stats-update-script";
    runtimeInputs = [ curl jq common-updater-scripts ];
    text = ''
      set -euo pipefail
      url="$(curl --silent "https://api.github.com/repos/exelban/stats/tags?per_page=1")"
      version="$(echo "$url" | jq -r '.[0].name' | cut -c 2-)"
      update-source-version stats "$version" --file=./pkgs/by-name/st/stats/package.nix
    '';
  });

  meta = with lib; {
    description = "macOS system monitor in your menu bar";
    homepage = "https://github.com/exelban/stats";
    license = licenses.mit;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [ emilytrau Enzime donteatoreo ];
    platforms = platforms.darwin;
  };
})
