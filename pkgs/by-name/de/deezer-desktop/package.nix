{
  stdenv,
  lib,
  fetchurl,
  makeWrapper,
  electron,
}:

let
  version = "7.1.100";
  srcs = {
    x86_64-linux = fetchurl {
      url = "https://github.com/aunetx/deezer-linux/releases/download/v${version}/deezer-desktop-${version}-x64.tar.xz";
      hash = "sha256-KU7dmXXJGLVoDf/iHP3LBcbc/+ldTdYsRD3LyGvbvZc=";
    };
    aarch64-linux = fetchurl {
      url = "https://github.com/aunetx/deezer-linux/releases/download/v${version}/deezer-desktop-${version}-arm64.tar.xz";
      hash = "sha256-sLso74DJaJK/o8cYYHEI/XNXjcl1MgfkegsCEOw+79Y=";
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
