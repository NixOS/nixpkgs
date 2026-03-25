{
  lib,
  stdenvNoCC,
  fetchurl,
  _7zz,
  writeShellApplication,
  curl,
  common-updater-scripts,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "gatherv2";
  version = "0.39.1";

  src = fetchurl {
    url = "https://downloads.gather.town/desktop-v2/GatherV2-${finalAttrs.version}-universal.dmg";
    hash = "sha256-+nNuObbzG4S8WztN6i5U5ZDM+wXSWRxs4XiTyG7sNDs=";
  };

  dontBuild = true;
  dontFixup = true;

  nativeBuildInputs = [ _7zz ];

  sourceRoot = ".";

  unpackPhase = ''
    runHook preUnpack
    7zz x -sns- "$src"
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/Applications"
    cp -R GatherV2*/GatherV2.app "$out/Applications/GatherV2.app"
    mkdir -p "$out/bin"
    ln -s "$out/Applications/GatherV2.app/Contents/MacOS/GatherV2" "$out/bin/gatherv2"

    runHook postInstall
  '';

  passthru.updateScript = lib.getExe (writeShellApplication {
    name = "gatherv2-update-script";
    runtimeInputs = [
      curl
      common-updater-scripts
    ];
    text = ''
      version=$(
        curl -sI https://api.v2.gather.town/api/v2/releases/latest/macos/v2 \
          | grep -i '^location:' \
          | grep -oE '[0-9]+\.[0-9]+\.[0-9]+'
      )
      update-source-version gatherv2 "$version" --file=./pkgs/by-name/ga/gatherv2/package.nix
    '';
  });

  meta = {
    description = "Virtual office and event space for remote collaboration (v2 client)";
    homepage = "https://www.gather.town";
    license = lib.licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ kaynetik ];
    platforms = [
      "aarch64-darwin"
      "x86_64-darwin"
    ];
    mainProgram = "gatherv2";
  };
})
