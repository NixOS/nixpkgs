{
  lib,
  appimageTools,
  fetchurl,
  webkitgtk_4_1,
  libsoup_3,
  glib-networking,
}:

let
  pname = "mongrel";
  version = "5.71.41";

  src = fetchurl {
    url = "https://downloads.visorcraft.com/mongrel/${version}/Mongrel_${version}_amd64.AppImage";
    hash = "sha256-brOsELYwzD01yJ2rQnTsmPtvuIY6sGhB8AldCUGrigY=";
  };

  appimageContents = appimageTools.extract {
    inherit pname version src;
  };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraPkgs = pkgs: [
    webkitgtk_4_1
    libsoup_3
    glib-networking
  ];

  extraInstallCommands = ''
    install -m 444 -D ${appimageContents}/mongrel.desktop -t $out/share/applications
    cp -r ${appimageContents}/usr/share/icons $out/share
  '';

  meta = {
    description = "Desktop workbench for databases, terminals, and API clients";
    longDescription = ''
      Mongrel is a multi-database desktop workbench covering 30+ database
      engines, with SSH/Mosh/Telnet/Serial terminals, SFTP/SCP, Docker/Podman,
      Kubernetes, and an HTTP/GraphQL/WebSocket/gRPC API client.
    '';
    homepage = "https://www.visorcraft.com/";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ visorcraft ];
    mainProgram = "mongrel";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
