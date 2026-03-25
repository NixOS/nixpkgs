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
  pname = "gatherv1";
  version = "1.35.1";

  src = fetchurl {
    url = "https://downloads.gather.town/desktop/Gather-${finalAttrs.version}-universal.dmg";
    hash = "sha256-3EPNd+UmafpVlNSeejqTXdvv3WsezZHF6upfs9ji2no=";
  };

  dontBuild = true;
  dontFixup = true;

  nativeBuildInputs = [ _7zz ];

  sourceRoot = "Gather.app";

  unpackPhase = ''
    runHook preUnpack
    7zz x -sns- "$src"
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/Applications/Gather.app"
    cp -R . "$out/Applications/Gather.app"
    mkdir -p "$out/bin"
    ln -s "$out/Applications/Gather.app/Contents/MacOS/Gather" "$out/bin/gatherv1"

    runHook postInstall
  '';

  passthru.updateScript = lib.getExe (writeShellApplication {
    name = "gatherv1-update-script";
    runtimeInputs = [
      curl
      common-updater-scripts
    ];
    text = ''
      version=$(
        curl -sI https://api.v2.gather.town/api/v2/releases/latest/macos/v1 \
          | grep -i '^location:' \
          | grep -oE '[0-9]+\.[0-9]+\.[0-9]+'
      )
      update-source-version gatherv1 "$version" --file=./pkgs/by-name/ga/gatherv1/package.nix
    '';
  });

  meta = {
    description = "Virtual office and event space for remote collaboration (legacy v1 client)";
    homepage = "https://www.gather.town";
    license = lib.licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ kaynetik ];
    platforms = [
      "aarch64-darwin"
      "x86_64-darwin"
    ];
    mainProgram = "gatherv1";
  };
})
