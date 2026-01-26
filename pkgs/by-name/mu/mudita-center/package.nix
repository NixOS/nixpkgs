{
  lib,
  stdenv,
  fetchurl,
  undmg,
  appimageTools,
  makeWrapper,
}:

let

  pname = "mudita-center";
  version = "3.2.0";

  src =
    fetchurl
      {
        x86_64-darwin = {
          url = "https://github.com/mudita/mudita-center/releases/download/${version}/Mudita-Center.dmg";
          hash = "sha256-mVIEKDaMqIXfSN6lxF1uYfRXK2P3RJAW5j3Y/TT2KN4=";
        };
        x86_64-linux = {
          url = "https://github.com/mudita/mudita-center/releases/download/${version}/Mudita-Center.AppImage";
          hash = "sha256-8eRDtUgK6ATTaQ/o1IJNbB5X0gO0lUcDbRo+LQvTun0=";
        };
      }
      .${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.system}");

  meta = {
    description = "Official updater for Mudita devices";
    homepage = "https://mudita.com/products/software-apps/mudita-center/";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ hackeryarn ];
    mainProgram = "mudita-center";
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
    nativeBuildInputs = [ makeWrapper ];
    extraInstallCommands = ''
      wrapProgram $out/bin/mudita-center \
        --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}"
      mkdir -p $out/share/{applications,mudita-center}
      cp -a ${appimageContents}/{locales,resources} $out/share/mudita-center
      cp -a ${appimageContents}/usr/share/icons $out/share
      install -Dm 444 ${appimageContents}/mudita-center.desktop $out/share/applications
      substituteInPlace $out/share/applications/mudita-center.desktop \
      --replace-fail 'Exec=AppRun' 'Exec=mudita-center'
    '';
  }
