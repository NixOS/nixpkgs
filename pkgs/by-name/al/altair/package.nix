{
  lib,
  appimageTools,
  makeWrapper,
  fetchurl,
}:

let
  pname = "altair";
  version = "8.3.0";

  src = fetchurl {
    url = "https://github.com/imolorhe/altair/releases/download/v${version}/altair_${version}_x86_64_linux.AppImage";
    sha256 = "sha256-uLqtrF5WWJ5+6bN/h4u/vdvTlbQtZID1osujfuJad4U=";
  };

  appimageContents = appimageTools.extract { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit src pname version;

  nativeBuildInputs = [ makeWrapper ];

  extraInstallCommands = ''
    wrapProgram $out/bin/${pname} \
        --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}"

    install -m 444 -D ${appimageContents}/${pname}.desktop -t $out/share/applications
    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'
    cp -r ${appimageContents}/usr/share/icons $out/share
  '';

  meta = with lib; {
    description = "Feature-rich GraphQL Client IDE";
    mainProgram = "altair";
    homepage = "https://github.com/imolorhe/altair";
    license = licenses.mit;
    maintainers = with maintainers; [ evalexpr ];
    platforms = [ "x86_64-linux" ];
  };
}
