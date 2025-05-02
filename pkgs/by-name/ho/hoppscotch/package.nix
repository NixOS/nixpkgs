{ lib
, stdenv
, fetchurl
, appimageTools
, undmg
}:

let
  pname = "hoppscotch";
  version = "24.3.2-1";

  src = fetchurl {
    aarch64-darwin = {
      url = "https://github.com/hoppscotch/releases/releases/download/v${version}/Hoppscotch_mac_aarch64.dmg";
      hash = "sha256-/Sa51x/Hy4mOxNL+6r+5sk/cF4iBbup9UBaWqzsnrBM=";
    };
    x86_64-darwin = {
      url = "https://github.com/hoppscotch/releases/releases/download/v${version}/Hoppscotch_mac_x64.dmg";
      hash = "sha256-6vm3pQPg5OKRtP6W1CNQxy4fi9niw4Y4nXjargwHxuA=";
    };
    x86_64-linux = {
      url = "https://github.com/hoppscotch/releases/releases/download/v${version}/Hoppscotch_linux_x64.AppImage";
      hash = "sha256-iGD/9alVwSsIhbSl9HZXdB5MQNSjn18YdgebyoizriE=";
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
