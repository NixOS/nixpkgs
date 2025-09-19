{
  lib,
  stdenv,
  fetchurl,
  undmg,
  appimageTools,
}:
let
  pname = "ezytdl";
  version = "3.0.0-dev.443";
  src =
    fetchurl
      {
        x86_64-darwin = {
          url = "https://github.com/sylviiu/ezytdl/releases/download/${version}/ezytdl-darwin.dmg";
          hash = "sha256-LHKc5vX2A7TvKn0TxSfhN09my4LvQ3O0N9TaYrpb1Fg=";
        };
        x86_64-linux = {
          url = "https://github.com/sylviiu/ezytdl/releases/download/${version}/ezytdl-linux.AppImage";
          hash = "sha256-bLqAwaa6LOa4jtGr1PUqAlVz2cGOdRl3nMFz3SCtNXM=";
        };
      }
      .${stdenv.system} or (throw "Unsupported system: ${stdenv.system}");

  appimageContents = appimageTools.extractType2 { inherit pname version src; };

  meta = {
    description = "Advanced electron-based frontend for yt-dlp";
    homepage = "https://github.com/sylviiu/ezytdl";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ ByteSudoer ];
    mainProgram = "ezytdl";
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
      mv *.app $out/Applications

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
      mkdir -p $out/share/{ezytdl,applications}
      cp -a ${appimageContents}/{locales,resources} $out/share/ezytdl
      cp -a ${appimageContents}/usr/share/icons $out/share
      install -Dm 444 ${appimageContents}/ezytdl.desktop -t $out/share/applications/
    '';
  }
