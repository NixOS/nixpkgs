{ lib
, stdenv
, fetchurl
, undmg
, appimageTools
}:
let
  pname = "devhub";
  version = "0.102.0";
  sources = {
    x86_64-darwin = {
      url = "https://github.com/devhubapp/devhub/releases/download/v${version}/DevHub-${version}.dmg";
      hash = "sha256-1vNI++u9mssvCkVU/6tjVHmrPyEFwKlLbB113c+S1MI=";
    };
    x86_64-linux = {
      url = "https://github.com/devhubapp/devhub/releases/download/v${version}/DevHub-${version}.AppImage";
      hash = "sha256-KGIEM8+dNhUeIXhu1nuo78XA+EUXvLrYeaMHk+VY0sY=";
    };
  };

  src = fetchurl (sources.${stdenv.system} or (throw "Unsupported system: ${stdenv.system}"));
  meta = {
    homepage = "https://devhubapp.com/";
    changelog = "https://github.com/devhubapp/devhub/releases/tag/v${version}";
    description = "Desktop app to help you manage GitHub Notifications";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ ByteSudoer ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = lib.attrNames sources;
  };


in
if stdenv.isDarwin then
  stdenv.mkDerivation
  {
    inherit pname version src meta;
    nativeBuildInputs = [ undmg ];
    installPhase = ''
      runHook preInstall

      mkdir -p "$out/Applications"
      install -D DevHub.app -t "$out/Applications"

      runHook postInstall
    '';

  }
else
  appimageTools.wrapType2 {
    inherit pname version src meta;

  }
