{
  lib,
  stdenv,
  _7zz,
  fetchurl,
}:
let
  common = import ./common.nix { inherit fetchurl; };
  inherit (stdenv.hostPlatform) system;
in
stdenv.mkDerivation rec {
  inherit (common) pname version;
  src = common.sources.${system} or (throw "Source for ${pname} is not available for ${system}");

  appName = "Roam Research";

  sourceRoot = ".";

  nativeBuildInputs = [ _7zz ];
  installPhase = ''
    runHook preInstall

    mkdir -p "$out/Applications"
    cp -R *.app "$out/Applications"

    mkdir -p $out/bin
    ln -s "$out/Applications/${appName}.app/Contents/MacOS/${appName}" "$out/bin/${appName}"
    runHook postInstall
  '';

  meta = {
    description = "Note-taking tool for networked thought";
    homepage = "https://roamresearch.com/";
    maintainers = with lib.maintainers; [ dbalan ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    platforms = [
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    mainProgram = "roam-research";
  };
}
