{
  lib,
  stdenv,
  fetchurl,
  appimageTools,
  undmg,
}:

let
  pname = "hoppscotch";
  version = "25.3.2-0";

  src =
    fetchurl
      {
        aarch64-darwin = {
          url = "https://github.com/hoppscotch/releases/releases/download/v${version}/Hoppscotch_mac_aarch64.dmg";
          hash = "sha256-l8R6pWu8lJSuji8lITFJFUagvFUFbJ5KKUBJ/1jE9WI=";
        };
        x86_64-darwin = {
          url = "https://github.com/hoppscotch/releases/releases/download/v${version}/Hoppscotch_mac_x64.dmg";
          hash = "sha256-6HT2IwdjaMjf+PcN6/keCSIqKAIOsQqocEibA+v5GJc=";
        };
        x86_64-linux = {
          url = "https://github.com/hoppscotch/releases/releases/download/v${version}/Hoppscotch_linux_x64.AppImage";
          hash = "sha256-TpR0vfOba34C+BMi5Yn1C1M83gPXzRnqi1w0+Jt5GNc=";
        };
      }
      .${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  passthru.updateScript = ./update.sh;

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
      passthru
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
      passthru
      meta
      ;

    extraInstallCommands =
      let
        appimageContents = appimageTools.extractType2 { inherit pname version src; };
      in
      ''
        # Install .desktop files
        install -Dm444 ${appimageContents}/Hoppscotch.desktop $out/share/applications/hoppscotch.desktop
        install -Dm444 ${appimageContents}/Hoppscotch.png $out/share/pixmaps/hoppscotch.png
        substituteInPlace $out/share/applications/hoppscotch.desktop \
          --replace-fail "hoppscotch-desktop" "hoppscotch"
      '';
  }
