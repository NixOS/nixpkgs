{
  lib,
  stdenvNoCC,
  fetchurl,
}:

let
  version = "1.17.1";
  systemMap = {
    "x86_64-linux" = {
      url = "https://github.com/raydak-labs/configarr/releases/download/v${version}/configarr-linux-x64.tar.xz";
      hash = "sha256:786d8c4c3921cbc4fc2df21ecdd3945046c178776db952bf3e038138f1ac8110";
    };
    "aarch64-linux" = {
      url = "https://github.com/raydak-labs/configarr/releases/download/v${version}/configarr-linux-arm64.tar.xz";
      hash = "sha256:9f2754176b54d44308b46dd2efb8a40d73aa5491c4d7f4b1325b0ed0c536577f";
    };
    "x86_64-darwin" = {
      url = "https://github.com/raydak-labs/configarr/releases/download/v${version}/configarr-darwin-x64.tar.xz";
      hash = "sha256:4016be5500b47c029d6c3a396d2624846ebc0dc0bfa1aeeb8fe5ad11d42f4a4f";
    };
    "aarch64-darwin" = {
      url = "https://github.com/raydak-labs/configarr/releases/download/v${version}/configarr-darwin-arm64.tar.xz";
      hash = "sha256:744239eba8566e91fbbcc64a685e25e434de55aae036af0e0256f297ce73f119";
    };
  };
in
stdenvNoCC.mkDerivation {
  pname = "configarr";
  inherit version;

  src = fetchurl (systemMap.${stdenvNoCC.hostPlatform.system} or
    (throw "Configarr does not support system: ${stdenvNoCC.hostPlatform.system}"));

  dontConfigure = true;
  dontBuild = true;
  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    install -Dm755 configarr $out/bin/configarr

    runHook postInstall
  '';

  meta = {
    description = "Sync TRaSH Guides + custom configs with *arr applications";
    homepage = "https://configarr.de";
    changelog = "https://github.com/raydak-labs/configarr/releases/tag/v${version}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ BlackDark ];
    mainProgram = "configarr";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
