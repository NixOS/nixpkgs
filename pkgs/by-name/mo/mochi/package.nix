{
  _7zz,
  appimageTools,
  fetchurl,
  lib,
  stdenvNoCC,
  libxshmfence,
}:

let
  pname = "mochi";
  version = "1.20.5";

  appName = "Mochi";

  linux = appimageTools.wrapType2 rec {
    inherit pname version meta;

    src = fetchurl {
      url = "https://download.mochi.cards/releases/Mochi-${version}.AppImage";
      hash = "sha256-QOJ1bigmoUm+CEW5gKB73arCTF4yG8RWsJ22NHv8YCo=";
    };

    appimageContents = appimageTools.extractType2 { inherit pname version src; };

    extraPkgs = pkgs: [ libxshmfence ];

    extraInstallCommands = ''
      install -Dm444 ${appimageContents}/${pname}.desktop -t $out/share/applications/
      install -Dm444 ${appimageContents}/${pname}.png -t $out/share/pixmaps/
      substituteInPlace $out/share/applications/${pname}.desktop \
        --replace-fail 'Exec=AppRun --no-sandbox' 'Exec=${pname}'
    '';
  };

  darwin = stdenvNoCC.mkDerivation {
    inherit
      pname
      version
      meta
      appName
      ;

    src = fetchurl {
      url = "https://download.mochi.cards/releases/Mochi-${version}.dmg";
      hash = "sha256-+fhsjr6Ek0wzZLHFi3oJEZxXhCliEjO+5/5HN4ehw1w=";
    };

    sourceRoot = "${appName}.app";
    nativeBuildInputs = [ _7zz ];

    installPhase = ''
      runHook preInstall

      mkdir -p $out/Applications/Mochi.app
      cp -r . $out/Applications/Mochi.app

      runHook postInstall
    '';

    dontUpdateAutotoolsGnuConfigScripts = true;
    dontConfigure = true;
    dontFixup = true;
  };

  meta = {
    description = "Simple markdown-powered SRS app";
    homepage = "https://mochi.cards/";
    changelog = "https://mochi.cards/changelog";
    mainProgram = "mochi";
    license = lib.licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ poopsicles ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
in
if stdenvNoCC.hostPlatform.isDarwin then darwin else linux
