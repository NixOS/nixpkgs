{
  lib,
  stdenv,
  fetchurl,
  appimageTools,
  undmg,
}:

let
  pname = "hoppscotch";
  version = "24.11.0-0";

  src =
    fetchurl
      {
        aarch64-darwin = {
          url = "https://github.com/hoppscotch/releases/releases/download/v${version}/Hoppscotch_mac_aarch64.dmg";
          hash = "sha256-MvLaAURzcNkG+kHFiMb7vliucJOzfqU3skeUGWiiKBY=";
        };
        x86_64-darwin = {
          url = "https://github.com/hoppscotch/releases/releases/download/v${version}/Hoppscotch_mac_x64.dmg";
          hash = "sha256-2LlsBgiu2LWkK8+VAT7FvZ1YPDtNla+t8YDZF0GalxI=";
        };
        x86_64-linux = {
          url = "https://github.com/hoppscotch/releases/releases/download/v${version}/Hoppscotch_linux_x64.AppImage";
          hash = "sha256-xUtpoKilueiMD+2Yd58jlxq2UPwp9oUzusB9sbJQulk=";
        };
      }
      .${stdenv.system} or (throw "Unsupported system: ${stdenv.system}");

  meta = {
    description = "Open source API development ecosystem";
    longDescription = ''
      Hoppscotch is a lightweight, web-based API development suite. It was built
      from the ground up with ease of use and accessibility in mind providing
      all the functionality needed for API developers with minimalist,
      unobtrusive UI.
    '';
    homepage = "https://hoppscotch.com";
    downloadPage = "https://hoppscotch.com/downloads";
    changelog = "https://github.com/hoppscotch/hoppscotch/releases/tag/20${lib.head (lib.splitString "-" version)}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ DataHearth ];
    mainProgram = "hoppscotch";
    platforms = [
      "aarch64-darwin"
      "x86_64-darwin"
      "x86_64-linux"
    ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
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

      mkdir -p "$out/Applications"
      mv Hoppscotch.app $out/Applications/

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
