{
  lib,
  stdenv,
  appimageTools,
  fetchurl,
  nix-update-script,
}:

let
  pname = "raiderio-client";
  version = "5.0.9";

  sources = {
    x86_64-linux = {
      arch = "x86_64";
      hash = "sha256-5CHwMgG2xybMjeUa2GqrGA0vKz84n7Vsn6F8KD0pQD0=";
    };
    aarch64-linux = {
      arch = "arm64";
      hash = "sha256-RG6DAQ9dt9mp8FhFJ7VSqFXiF9rGl/LHtQQmAAGnAE0=";
    };
  };

  source =
    sources.${stdenv.hostPlatform.system}
      or (throw "Unsupported platform: ${stdenv.hostPlatform.system}");

  src = fetchurl {
    url = "https://github.com/RaiderIO/raiderio-client-builds/releases/download/v${version}/RaiderIO_Installer_Linux_${source.arch}.AppImage";
    inherit (source) hash;
  };

  appimageContents = appimageTools.extract {
    inherit pname version src;
  };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    install -m 444 -D ${appimageContents}/io.raider.client.desktop $out/share/applications/io.raider.client.desktop
    substituteInPlace $out/share/applications/io.raider.client.desktop \
      --replace-fail 'Exec=AppRun --no-sandbox %U' 'Exec=raiderio-client --no-sandbox %U'
    install -m 444 -D ${appimageContents}/usr/share/icons/hicolor/scalable/apps/raiderio-client.svg $out/share/icons/hicolor/scalable/apps/raiderio-client.svg
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "^v(.*)$"
    ];
  };

  meta = {
    description = "RaiderIO Desktop Client for World of Warcraft";
    homepage = "https://raider.io";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ thebigjc ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    mainProgram = "raiderio-client";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
