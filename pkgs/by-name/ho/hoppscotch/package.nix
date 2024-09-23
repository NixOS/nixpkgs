{
  lib,
  stdenv,
  fetchurl,
  appimageTools,
  undmg,
}:

let
  pname = "hoppscotch";
  version = "24.8.1-0";

  src =
    fetchurl
      {
        aarch64-darwin = {
          url = "https://github.com/hoppscotch/releases/releases/download/v${version}/Hoppscotch_mac_aarch64.dmg";
          hash = "sha256-Tc6lQbMZHX4Wl0R3fGClRr27fFTrYTxMtAkSPCw8mrw=";
        };
        x86_64-darwin = {
          url = "https://github.com/hoppscotch/releases/releases/download/v${version}/Hoppscotch_mac_x64.dmg";
          hash = "sha256-c3UHntrLRoXfmz8LL3Xu8mjBtyf952/tYMFqbTyECR0=";
        };
        x86_64-linux = {
          url = "https://github.com/hoppscotch/releases/releases/download/v${version}/Hoppscotch_linux_x64.AppImage";
          hash = "sha256-Aegc4kiLPtY+hlQtfYR3uztqs8Gj9fbUcAZ1XB8i1Pw=";
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
