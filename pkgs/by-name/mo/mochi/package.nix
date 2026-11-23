{
  appimageTools,
  fetchurl,
  imagemagick,
  lib,
  makeWrapper,
  stdenv,
  stdenvNoCC,
  libxshmfence,
  undmg,
}:

let
  pname = "mochi";
  version = "26.11.2";

  linux = appimageTools.wrapType2 (finalAttrs: {
    inherit pname version meta;

    src = fetchurl {
      url = "https://download.mochi.cards/releases/Mochi-${version}.AppImage";
      hash = "sha256-LVDb5sjTzr/smvLpzvyJ4C16FEEIFDbOLMmp5V4K+vE=";
    };

    extraPkgs = pkgs: [ libxshmfence ];

    extraInstallCommands = ''
      install -Dm444 ${finalAttrs.contents}/mochi.desktop -t $out/share/applications/
      ${lib.getExe imagemagick} ${finalAttrs.contents}/mochi.png -resize 512x512 mochi_512.png
      install -Dm444 mochi_512.png $out/share/icons/hicolor/512x512/apps/mochi.png
      substituteInPlace $out/share/applications/mochi.desktop \
        --replace-fail 'Exec=AppRun --no-sandbox' 'Exec=mochi'
    '';

    passthru.updateScript = ./update.sh;
  });

  darwin = stdenv.mkDerivation {
    inherit pname version meta;

    src = fetchurl {
      url = "https://download.mochi.cards/releases/Mochi-${version}-arm64.dmg";
      hash = "sha256-+vNlaTwWw3qIoXM2IV9H8xKtUh46XAVLsDeK24HTDKA=";
    };

    sourceRoot = ".";

    nativeBuildInputs = [
      makeWrapper
      undmg
    ];

    installPhase = ''
      runHook preInstall

      mkdir -p $out/{Applications,bin}
      cp -a Mochi.app $out/Applications
      makeWrapper $out/Applications/Mochi.app/Contents/MacOS/Mochi $out/bin/mochi

      runHook postInstall
    '';
  };

  meta = {
    description = "Simple markdown-powered SRS app";
    homepage = "https://mochi.cards/";
    changelog = "https://mochi.cards/changelog.html";
    license = lib.licenses.unfree;
    mainProgram = "mochi";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [
      piotrkwiecinski
      dibenzepin
    ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
in
if stdenvNoCC.hostPlatform.isDarwin then darwin else linux
