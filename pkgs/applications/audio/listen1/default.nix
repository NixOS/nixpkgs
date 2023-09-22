{ lib, fetchurl, appimageTools, makeWrapper }:

let
  pname = "listen1";
  version = "2.31.0";
  name = "listen1-${version}";
  nameExecutable = pname;
  src = fetchurl {
    url = "https://github.com/listen1/listen1_desktop/releases/download/v${version}/listen1_${version}_linux_x86_64.AppImage";
    name = "listen1-${version}.AppImage";
    sha256 = "9d80ca7b157356ec0f9affde2bd701d280128171196eb3ebcea3eee4e1e4e8d4";
  };
  appimageContents = appimageTools.extractType2 { inherit name src; };
in
appimageTools.wrapType2 {
  inherit name src;

  extraPkgs = pkgs: (appimageTools.defaultFhsEnvArgs.multiPkgs pkgs)
    ++ [ pkgs.libsecret ];

  extraInstallCommands = ''
    mv $out/bin/${name} $out/bin/${pname}
    source "${makeWrapper}/nix-support/setup-hook"
    wrapProgram $out/bin/${pname} \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}"
    install -m 444 -D ${appimageContents}/listen1.desktop -t $out/share/applications
    substituteInPlace $out/share/applications/listen1.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'
    install -m 444 -D ${appimageContents}/usr/share/icons/hicolor/512x512/apps/listen1.png \
      $out/share/icons/hicolor/512x512/apps/listen1.png
  '';

  meta = with lib; {
    description = "One for all free music in China";
    homepage = "http://listen1.github.io/listen1/";
    license = licenses.mit;
    maintainers = with maintainers; [ bbigras ];
    platforms = [ "x86_64-linux" ];
  };
}
