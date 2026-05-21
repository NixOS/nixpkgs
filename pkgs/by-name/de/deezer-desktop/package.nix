{
  stdenv,
  lib,
  fetchurl,
  makeWrapper,
  electron,
  writeScript,
}:

let
  version = "7.1.190";
  srcs = {
    x86_64-linux = fetchurl {
      url = "https://github.com/aunetx/deezer-linux/releases/download/v${version}/deezer-desktop-${version}-x64.tar.xz";
      hash = "sha256-XoZRlFMiN5VVp3vkTwGDMekhW1KzmvuN9oYTXZFn6B4=";
    };
    aarch64-linux = fetchurl {
      url = "https://github.com/aunetx/deezer-linux/releases/download/v${version}/deezer-desktop-${version}-arm64.tar.xz";
      hash = "sha256-ChPuz8wd3SOxRmxM5bEbz3paBw7pfIVfSY23nasRI4A=";
    };
  };

  src = srcs.${stdenv.hostPlatform.system} or (throw "${stdenv.hostPlatform.system} not supported");

  # Architecture string for directory names
  archDir =
    if stdenv.hostPlatform.isx86_64 then
      "x64"
    else if stdenv.hostPlatform.isAarch64 then
      "arm64"
    else
      throw "Unsupported architecture";
in

stdenv.mkDerivation (finalAttrs: {
  pname = "deezer-desktop";
  inherit version src;

  nativeBuildInputs = [
    makeWrapper
  ];

  sourceRoot = ".";

  dontBuild = true;
  installPhase = ''
    runHook preInstall
    install -d $out/bin $out/share/deezer-desktop/resources $out/share/applications $out/share/icons/hicolor/scalable/apps

    substituteInPlace deezer-desktop-${version}-${archDir}/resources/dev.aunetx.deezer.desktop \
      --replace-fail "run.sh" "deezer-desktop" \
      --replace-fail "dev.aunetx.deezer" "deezer-desktop"
    cp deezer-desktop-${version}-${archDir}/resources/dev.aunetx.deezer.desktop $out/share/applications/deezer-desktop.desktop
    cp deezer-desktop-${version}-${archDir}/resources/dev.aunetx.deezer.svg $out/share/icons/hicolor/scalable/apps/deezer-desktop.svg
    cp -r deezer-desktop-${version}-${archDir}/resources/{app.asar,linux} $out/share/deezer-desktop/resources/

    makeWrapper "${lib.getExe electron}" "$out/bin/deezer-desktop" \
      --inherit-argv0 \
      --add-flags "$out/share/deezer-desktop/resources/app.asar" \
      --set-default ELECTRON_FORCE_IS_PACKAGED 1 \
      --set DZ_RESOURCES_PATH "$out/share/deezer-desktop/resources"

    runHook postInstall
  '';

  passthru = {
    inherit srcs;
    updateScript = writeScript "update-deezer-desktop" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p curl jq common-updater-scripts
      set -eu -o pipefail

      latest_version="$(
        curl --fail --silent --show-error --location \
          'https://api.github.com/repos/aunetx/deezer-linux/releases/latest' |
          jq -r '.tag_name | ltrimstr("v")'
      )"

      for platform in ${lib.escapeShellArgs (lib.attrNames srcs)}; do
        update-source-version "${finalAttrs.pname}" "$latest_version" --ignore-same-version --source-key="passthru.srcs.$platform"
      done
    '';
  };

  meta = {
    description = "Unofficial Linux port of the music streaming application";
    homepage = "https://github.com/aunetx/deezer-linux";
    downloadPage = "https://github.com/aunetx/deezer-linux/releases";
    platforms = lib.platforms.linux;
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ FelixLusseau ];
    mainProgram = "deezer-desktop";
  };
})
