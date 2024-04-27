{ lib
, stdenv
, fetchurl
, appimageTools
, undmg
, nix-update-script
}:

let
  pname = "hoppscotch";
  version = "23.12.5";

  src = fetchurl {
    aarch64-darwin = {
      url = "https://github.com/hoppscotch/releases/releases/download/v${version}-1/Hoppscotch_mac_aarch64.dmg";
      hash = "sha256-WUJW38vQ7o5KEmCxhVnJ03/f5tPOTYcczrEcmt6NSCY=";
    };
    x86_64-darwin = {
      url = "https://github.com/hoppscotch/releases/releases/download/v${version}-1/Hoppscotch_mac_x64.dmg";
      hash = "sha256-bQFD+9IoelinWYUndzbVvPNaRde6ACPvw9ifX9mYdno=";
    };
    x86_64-linux = {
      url = "https://github.com/hoppscotch/releases/releases/download/v${version}-1/Hoppscotch_linux_x64.AppImage";
      hash = "sha256-MYQ7SRm+CUPIXROZxejbbZ0/wH+U5DQO4YGbE/HQAj8=";
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
