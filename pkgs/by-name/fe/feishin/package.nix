{
  lib,
  stdenv,
  fetchurl,
  appimageTools,
  undmg,
  makeDesktopItem,
  ...
}:
let
  pname = "feishin";
  version = "0.21.2";

  src = fetchurl {
    url =
      if stdenv.hostPlatform.isDarwin then
        "https://github.com/jeffvli/feishin/releases/download/v${version}/Feishin-${version}-mac-${if stdenv.hostPlatform.isAarch64 then "arm64" else "x64"}.dmg"
      else
        "https://github.com/jeffvli/feishin/releases/download/v${version}/Feishin-linux-${if stdenv.hostPlatform.isAarch64 then "arm64" else "x86_64"}.AppImage";
    hash =
      # macOS
      if stdenv.hostPlatform.isDarwin then
        if stdenv.hostPlatform.isAarch64 then
          "sha256-F4u9sFMuRlNQz5PDuMKdEZG5IbYhZF6kRZUrPF2bzQg="
        else
          "sha256-YK3QMJ55ENqV6PCflWIaRJi8Xy5H4Hl3tc+/HazzZFc="
      # Linux
      else
        if stdenv.hostPlatform.isAarch64 then
          "sha256-ToaBmxy+Tvv7DNF9UgrBitTVcYetVHbMwW2W0SiodKw="
        else
          "sha256-CDYI9xTPpU89SrXvPZ7Qm2c0piuW11qjAgXZWxtspSY=";
  };

  appimageContents = appimageTools.extract { inherit pname version src; };

  desktopItem = makeDesktopItem {
    name = "feishin";
    desktopName = "Feishin";
    genericName = "Music player";
    exec = "feishin %u";
    icon = "feishin";
    startupWMClass = "feishin";
    categories = [
      "AudioVideo"
      "Audio"
      "Player"
      "Music"
    ];
    keywords = [
      "Navidrome"
      "Jellyfin"
      "Subsonic"
      "OpenSubsonic"
    ];
    comment = "A player for your self-hosted music server";
  };

  meta = {
    description = "Full-featured Subsonic/Jellyfin compatible desktop music player";
    homepage = "https://github.com/jeffvli/feishin";
    changelog = "https://github.com/jeffvli/feishin/releases/tag/v${version}";
    license = lib.licenses.gpl3Plus;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    maintainers = with lib.maintainers; [
      onny
      jlbribeiro
      FreeCap23
    ];
    mainProgram = "feishin";
  };
in
if stdenv.hostPlatform.isDarwin then
  stdenv.mkDerivation {
    inherit pname version src meta;

    nativeBuildInputs = [ undmg ];

    sourceRoot = ".";

    installPhase = ''
      runHook preInstall

      mkdir -p $out/Applications
      cp -r Feishin.app $out/Applications/

      runHook postInstall
    '';
  }
else
  appimageTools.wrapType2 {
    inherit pname version src meta;

    extraInstallCommands = ''
      mkdir -p $out/share/applications
      cp ${desktopItem}/share/applications/* $out/share/applications/
      cp -r ${appimageContents}/usr/share/icons $out/share
    '';
  }
