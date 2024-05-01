{ lib
, stdenv
, fetchurl
, appimageTools
, undmg
}:

let
  pname = "hoppscotch";
  version = "24.3.1-2";

  src = fetchurl {
    aarch64-darwin = {
      url = "https://github.com/hoppscotch/releases/releases/download/v${version}/Hoppscotch_mac_aarch64.dmg";
      hash = "sha256-F4vQwdNObIE8Fx75TfwI0QxbY5n2syT4sEIhgAu2Z5c=";
    };
    x86_64-darwin = {
      url = "https://github.com/hoppscotch/releases/releases/download/v${version}/Hoppscotch_mac_x64.dmg";
      hash = "sha256-itC6PdNdzcw5Lv/hQkT0AsTGQ8kmTwT6cipyaAynph8=";
    };
    x86_64-linux = {
      url = "https://github.com/hoppscotch/releases/releases/download/v${version}/Hoppscotch_linux_x64.AppImage";
      hash = "sha256-vj9UYizRmyIK9mLNSW/qFc/QmnWNhniqJf3gG66WPb0=";
    };
  }.${stdenv.system} or (throw "Unsupported system: ${stdenv.system}");

  meta = {
    description = "Open source API development ecosystem";
    mainProgram = "hoppscotch";
    homepage = "https://hoppscotch.com";
    changelog = "https://github.com/hoppscotch/hoppscotch/releases/tag/${version}";
    platforms = [ "aarch64-darwin" "x86_64-darwin" "x86_64-linux" ];
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ DataHearth ];
  };
in
if stdenv.isDarwin then stdenv.mkDerivation
{
  inherit pname version src meta;

  sourceRoot = ".";

  nativeBuildInputs = [ undmg ];

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/Applications"
    mv Hoppscotch.app $out/Applications/

    runHook postInstall
  '';
}
else appimageTools.wrapType2 {
  inherit pname version src meta;

  extraPkgs = pkgs:
    appimageTools.defaultFhsEnvArgs.multiPkgs pkgs;

  extraInstallCommands =
    let
      appimageContents = appimageTools.extractType2 { inherit pname version src; };
    in
    ''
      # Install .desktop files
      install -Dm444 ${appimageContents}/hoppscotch.desktop -t $out/share/applications
      install -Dm444 ${appimageContents}/hoppscotch.png -t $out/share/pixmaps
    '';
}
