{
  lib,
  stdenvNoCC,
  fetchurl,
  appimageTools,
}:
appimageTools.wrapType2 rec {
  pname = "deskreen";
  version = "3.2.16";

  src =
    let
      sources = {
        x86_64-linux = {
          arch = "x86_64";
          hash = "sha256-JcVKRINEWHJXzpdyiMSzx+cp/BzHBhrXRxYizQmkerI=";
        };
        aarch64-linux = {
          arch = "arm64";
          hash = "sha256-FDZz3Aarz9j8ppaLO6C1IhVKr7Dns77fLdQQCaCoKg0=";
        };
      };
      inherit (stdenvNoCC.hostPlatform) system;
    in
    fetchurl {
      url = "https://github.com/pavlobu/deskreen/releases/download/v${version}/deskreen-ce-${version}-${sources.${system}.arch}.AppImage";
      inherit (sources.${system}) hash;
    };
  extraInstallCommands =
    let
      contents = appimageTools.extractType2 { inherit pname version src; };
    in
    ''
      install -m 444 -D ${contents}/deskreen-ce.desktop $out/share/applications/deskreen-ce.desktop
      install -m 444 -D ${contents}/usr/share/icons/hicolor/256x256/apps/deskreen-ce.png \
        $out/share/icons/hicolor/512x512/apps/deskreen-ce.png
      substituteInPlace $out/share/applications/deskreen-ce.desktop \
        --replace-fail 'Exec=AppRun' 'Exec=deskreen'
    '';

  meta = {
    description = "Turn any device into a secondary screen for your computer";
    homepage = "https://deskreen.com";
    license = lib.licenses.agpl3Only;
    mainProgram = "deskreen";
    maintainers = with lib.maintainers; [
      leo248
    ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
}
