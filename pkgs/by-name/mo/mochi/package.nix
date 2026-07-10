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
  version = "1.21.16";

  linux = appimageTools.wrapType2 rec {
    inherit pname version meta;

    src = fetchurl {
      url = "https://download.mochi.cards/releases/Mochi-${version}.AppImage";
      hash = "sha256-LWwv/+2/djc2bdqhnJiG5etXg+MFaEZbpttewVBZdeg=";
    };

    appimageContents = appimageTools.extractType2 { inherit pname version src; };

    extraPkgs = pkgs: [ libxshmfence ];

    extraInstallCommands = ''
      install -Dm444 ${appimageContents}/${pname}.desktop -t $out/share/applications/
      ${lib.getExe imagemagick} ${appimageContents}/${pname}.png -resize 512x512 ${pname}_512.png
      install -Dm444 ${pname}_512.png $out/share/icons/hicolor/512x512/apps/${pname}.png
      substituteInPlace $out/share/applications/${pname}.desktop \
        --replace-fail 'Exec=AppRun --no-sandbox' 'Exec=${pname}'
    '';

    passthru.updateScript = ./update.sh;
  };

  darwin = stdenv.mkDerivation {
    inherit pname version meta;

    src = fetchurl {
      url = "https://download.mochi.cards/releases/Mochi-${version}${lib.optionalString stdenv.hostPlatform.isAarch64 "-arm64"}.dmg";
      hash =
        if stdenv.hostPlatform.isAarch64 then
          "sha256-dtdQZYGrukT/UgfNdsnGxOYmpuebJCDHXW8cAGN2GZE="
        else
          "sha256-FdNFpuIOMgRzniB9Aze3GUpNY27h++StTdwqfF1k07I=";
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
      makeWrapper $out/Applications/Mochi.app/Contents/MacOS/Mochi $out/bin/${pname}

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
      poopsicles
    ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
in
if stdenvNoCC.hostPlatform.isDarwin then darwin else linux
