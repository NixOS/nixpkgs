{
  _7zz,
  appimageTools,
  fetchurl,
  fetchzip,
  lib,
  stdenvNoCC,
  xorg,
}:

let
  pname = "mochi";
  version = "1.20.7";

  baseUrl = "https://download.mochi.cards/releases/";

  linux = appimageTools.wrapType2 rec {
    inherit pname version meta;

    src = fetchurl {
      url = baseUrl + "Mochi-${version}.AppImage";
      hash = "sha256-K8vOSOT2eAj8qwTlHaRCTbYg44FeGX2fnAEvknRIavA=";
    };

    appimageContents = appimageTools.extractType2 { inherit pname version src; };

    extraPkgs = pkgs: [ xorg.libxshmfence ];

    extraInstallCommands = ''
      install -Dm444 ${appimageContents}/${pname}.desktop -t $out/share/applications/
      install -Dm444 ${appimageContents}/${pname}.png -t $out/share/pixmaps/
      substituteInPlace $out/share/applications/${pname}.desktop \
        --replace-fail 'Exec=AppRun --no-sandbox' 'Exec=${pname}'
    '';
  };

  darwin = stdenvNoCC.mkDerivation {
    inherit pname version meta;

    src = fetchzip {
      url = baseUrl + "Mochi-${version}.dmg";
      hash = "sha256-ptmT0zUUdTIT6wscuZxSA0d2SjPHncTv20K1Z2N6sW4=";
      stripRoot = false;
      nativeBuildInputs = [ _7zz ];
    };

    installPhase = ''
      runHook preInstall

      mkdir -p $out/Applications
      cp -r *.app $out/Applications

      runHook postInstall
    '';
  };

  meta = {
    description = "Simple markdown-powered SRS app";
    homepage = "https://mochi.cards/";
    changelog = "https://mochi.cards/changelog.html";
    license = lib.licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ poopsicles ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
in
if stdenvNoCC.hostPlatform.isDarwin then darwin else linux
