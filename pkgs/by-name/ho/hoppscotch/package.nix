{ lib
, stdenv
, fetchurl
, appimageTools
, undmg
}:

let
  pname = "hoppscotch";
  version = "24.3.3-1";

  src = fetchurl {
    aarch64-darwin = {
      url = "https://github.com/hoppscotch/releases/releases/download/v${version}/Hoppscotch_mac_aarch64.dmg";
      hash = "sha256-litOYRsUOx6VpkA1LPx7aGGagqIVL9fgNsYoP5n/2mo=";
    };
    x86_64-darwin = {
      url = "https://github.com/hoppscotch/releases/releases/download/v${version}/Hoppscotch_mac_x64.dmg";
      hash = "sha256-UG89Fv9J8SnzPVoIO16LOprxPmZuu/zyox1b+jn+eNw=";
    };
    x86_64-linux = {
      url = "https://github.com/hoppscotch/releases/releases/download/v${version}/Hoppscotch_linux_x64.AppImage";
      hash = "sha256-110l1DTyvH2M0ex1r35Q+55NiJ8nYum1KdWQXDvAdxo=";
    };
  }.${stdenv.system} or (throw "Unsupported system: ${stdenv.system}");

  meta = with lib; {
    description = "Open source API development ecosystem";
    longDescription = ''
      Hoppscotch is a lightweight, web-based API development suite. It was built
      from the ground up with ease of use and accessibility in mind providing
      all the functionality needed for API developers with minimalist,
      unobtrusive UI.
    '';
    homepage = "https://hoppscotch.com";
    downloadPage = "https://hoppscotch.com/downloads";
    changelog = "https://hoppscotch.com/changelog";
    license = licenses.mit;
    maintainers = with maintainers; [ DataHearth ];
    mainProgram = "hoppscotch";
    platforms = [ "aarch64-darwin" "x86_64-darwin" "x86_64-linux" ];
    sourceProvenance = [ sourceTypes.binaryNativeCode ];
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
