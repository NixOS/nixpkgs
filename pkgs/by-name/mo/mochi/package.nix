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
  version = "26.10.1";

  linux = appimageTools.wrapType2 (finalAttrs: {
    inherit pname version meta;

    src = fetchurl {
      url = "https://download.mochi.cards/releases/Mochi-${version}.AppImage";
      hash = "sha256-dDF3R6KUoKWskMbFgRlQe6urgxJuv9PER/8hdc4Fkbg=";
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
      hash = "sha256-lISGBc1/xU3NbPfEX3mO1zLfLTThT7ozdse61gbqKG0=";
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
