{ lib
, stdenv
, appimageTools
, fetchurl
, makeWrapper
, pkgs
}:
let
  pname = "opendataeditor";
  version = "1.0.0";

  src = fetchurl {
    x86_64-darwin = {
      url = "https://github.com/okfn/${pname}/releases/download/v${version}/${pname}-mac-${version}.dmg";
      hash = "sha256-39HzXe7+BKkaP0/x+H4FlolQuy0bkqtLLpTbd7n2TkY=";
    };
    x86_64-linux = {
      url = "https://github.com/okfn/${pname}/releases/download/v${version}/${pname}-linux-${version}.AppImage";
      hash = "sha256-WTS2dX7j3ovfayu/iBbi5YfLKtLVhK3fFTqqTqQQemk=";
    };
  }.${stdenv.system} or (throw "Unsupported system: ${stdenv.system}");

  appimageContents = appimageTools.extractType2 { inherit pname version src; };

  meta = with lib; {
    homepage = "https://opendataeditor.okfn.org/";
    description = "No-code application to explore and publish all kinds of data";
    longDescription = ''
      No-code application to explore and publish all kinds of data: datasets, tables, charts, maps, stories, and more.
      Forever free and open source project powered by open standards and generative AI.
    '';
    license = licenses.mit;
    maintainers = with maintainers; [ ByteSudoer ];
    platforms = [ "x86_64-darwin" "x86_64-linux" ];
    mainProgram = "opendataeditor";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
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
      mv Open\ Data\ Editor.app $out/Applications/

      runHook postInstall
    '';
  }
else
  appimageTools.wrapType2 {
    inherit pname version src meta;

    extraPkgs = pkgs: [ pkgs.libxcrypt-legacy ];

    extraInstallCommands = ''
      mkdir -p $out/share/${pname}

      cp -a ${appimageContents}/{locales,resources} $out/share/${pname}
      cp -a ${appimageContents}/usr/share/icons $out/share/
      install -Dm 444 ${appimageContents}/${pname}.desktop -t $out/share/applications
    '';

  }
