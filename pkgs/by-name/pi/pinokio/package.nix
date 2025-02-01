{ lib
, stdenv
, fetchurl
, pkgs
, appimageTools
}:
let
  pname = "pinokio";
  version = "1.3.4";
  src = fetchurl {
    x86_64-darwin = {
      url = "https://github.com/pinokiocomputer/pinokio/releases/download/${version}/Pinokio-${version}.dmg";
      hash = "sha256-Il5zaVWu4icSsKmMjU9u1/Mih34fd+xNpF1nkFAFFGo=";
    };
    x86_64-linux = {
      url = "https://github.com/pinokiocomputer/pinokio/releases/download/${version}/Pinokio-${version}.AppImage";
      hash = "sha256-/E/IAOUgxH9RWpE2/vLlQy92LOgwpHF79K/1XEtSpXI=";
    };
  }.${stdenv.system} or (throw "Unsupported system: ${stdenv.system}");

  appimageContents = appimageTools.extractType2 { inherit pname version src; };

  meta = {
    homepage = "https://pinokio.computer";
    description = "Browser to install, run, and programmatically control ANY application automatically";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ByteSudoer ];
    platforms = [ "x86_64-darwin" "x86_64-linux" ];
    mainProgram = "pinokio";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
in

if stdenv.isDarwin then
  stdenv.mkDerivation
  {
    inherit pname version src meta;

    sourceRoot = ".";

    nativeBuildInputs = with pkgs; [ undmg ];

    installPhase = ''
      runHook preInstall
      mkdir -p "$out/Applications"
      mv Pinokio.app $out/Applications/
      runHook postInstall
    '';
  }
else
  appimageTools.wrapType2 {
    inherit pname version src meta;

    extraInstallCommands = ''
      mkdir -p $out/share/pinokio
      cp -a ${appimageContents}/{locales,resources} $out/share/pinokio
      cp -a ${appimageContents}/usr/share/icons $out/share/
      install -Dm 444 ${appimageContents}/pinokio.desktop -t $out/share/applications
    '';

  }
