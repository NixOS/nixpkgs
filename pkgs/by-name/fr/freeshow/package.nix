{
  lib,
  fetchurl,
  stdenv,
  undmg,
  appimageTools,
}:

let
  pname = "freeshow";
  version = "1.2.1";
  src =
    fetchurl
      {
        x86_64-darwin = {
          url = "https://github.com/ChurchApps/FreeShow/releases/download/v${version}/FreeShow-${version}.dmg";
          hash = "sha256-OO0uQ6oS1GKiBGz3Qt9jDCY+qdWlgTOY+SiLJB5xQ3c=";
        };
        x86_64-linux = {
          url = "https://github.com/ChurchApps/FreeShow/releases/download/v${version}/FreeShow-${version}.AppImage";
          hash = "sha256-RBI8IkxY6Xd36vCVDJy9sqpEisB/48hwQo+mg5XTCOs=";
        };
      }
      .${stdenv.system} or (throw "Unsupported system: ${stdenv.system}");

  appimageContents = appimageTools.extract { inherit pname version src; };

  meta = {
    description = "Free and open-source, user-friendly presenter software";
    homepage = "https://freeshow.app";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ ByteSudoer ];
    mainProgram = "freeshow";
    platforms = [
      "x86_64-darwin"
      "x86_64-linux"
    ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };

in
if stdenv.isDarwin then
  stdenv.mkDerivation {
    inherit
      pname
      version
      src
      meta
      ;

    sourceRoot = ".";

    nativeBuildInputs = [ undmg ];

    installPhase = ''
      runHook preInstall
      mkdir -p $out/Applications
      cp -r *.app $out/Applications/
      runHook postInstall
    '';
  }
else
  appimageTools.wrapType2 {
    inherit
      pname
      version
      src
      meta
      ;

    extraInstallCommands = ''
      mkdir -p $out/share/{applications,freeshow}
      cp -a ${appimageContents}/{locales,resources} $out/share/freeshow
      cp -a ${appimageContents}/usr/share/icons $out/share
      install -Dm 444 ${appimageContents}/freeshow.desktop $out/share/applications
    '';

  }
