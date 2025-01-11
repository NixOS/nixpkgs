{
  lib,
  stdenv,
  fetchurl,
  undmg,
  appimageTools,

}:

let

  pname = "sleek-todo";
  version = "2.0.14";

  src =
    fetchurl
      {
        x86_64-darwin = {
          url = "https://github.com/ransome1/sleek/releases/download/v${version}/sleek-2.0.14-mac-x64.dmg";
          hash = "sha256-f5mMSRa+gAoakOy9TSZeALqCylGLd0nUJIh8o+LWAro=";
        };
        x86_64-linux = {
          url = "https://github.com/ransome1/sleek/releases/download/v${version}/sleek-2.0.14.AppImage";
          hash = "sha256-d2fLsCI7peuNBtjgHs1qumgPAF9eJeBYiIIffoSv9Jk=";
        };
      }
      .${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.system}");

  meta = {
    description = "Todo manager based on todo.txt syntax";
    homepage = "https://github.com/ransome1/sleek";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ByteSudoer ];
    mainProgram = "sleek-todo";
    platforms = [
      "x86_64-linux"
      "x86_64-darwin"
    ];
  };
  appimageContents = appimageTools.extract { inherit pname version src; };
in
if stdenv.hostPlatform.isDarwin then
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
      mkdir -p $out/share/{applications,sleek}
      cp -a ${appimageContents}/{locales,resources} $out/share/sleek
      cp -a ${appimageContents}/usr/share/icons $out/share
      install -Dm 444 ${appimageContents}/sleek.desktop $out/share/applications
      substituteInPlace $out/share/applications/sleek.desktop \
      --replace-warn 'Exec=AppRun' 'Exec=${pname}'
    '';

  }
