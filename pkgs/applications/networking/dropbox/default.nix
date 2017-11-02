{ stdenv, lib, buildFHSUserEnv, writeScript, makeDesktopItem }:

let platforms = [ "i686-linux" "x86_64-linux" ]; in

assert lib.elem stdenv.system platforms;

# Dropbox client to bootstrap installation.
# The client is self-updating, so the actual version may be newer.
let
  version = "38.4.27";

  arch = {
    "x86_64-linux" = "x86_64";
    "i686-linux"   = "x86";
  }.${stdenv.system};

  installer = "https://clientupdates.dropboxstatic.com/dbx-releng/client/dropbox-lnx.${arch}-${version}.tar.gz";
in

let
  desktopItem = makeDesktopItem {
    name = "dropbox";
    exec = "dropbox";
    comment = "Sync your files across computers and to the web";
    desktopName = "Dropbox";
    genericName = "File Synchronizer";
    categories = "Network;FileTransfer;";
    startupNotify = "false";
  };
in

buildFHSUserEnv {
  name = "dropbox";

  targetPkgs = pkgs: with pkgs; with xlibs; [
    libICE libSM libX11 libXcomposite libXdamage libXext libXfixes libXrender
    libXxf86vm libxcb
    curl dbus fontconfig freetype gcc glib gnutar libxml2 libxslt zlib
  ];

  extraInstallCommands = ''
    mkdir -p "$out/share/applications"
    cp "${desktopItem}/share/applications/"* $out/share/applications
  '';

  runScript = writeScript "install-and-start-dropbox" ''
    if ! [ -d "$HOME/.dropbox-dist" ]; then
        # Dropbox is not installed.
        # Download and unpack the client. If a newer version is available,
        # the client will update itself when run.
        curl '${installer}' | tar -C "$HOME" -x -z
    fi
    exec "$HOME/.dropbox-dist/dropboxd"
  '';

  meta = with lib; {
    description = "Online stored folders (daemon version)";
    homepage    = http://www.dropbox.com/;
    license     = licenses.unfree;
    maintainers = with maintainers; [ ttuegel ];
    platforms   = [ "i686-linux" "x86_64-linux" ];
  };
}
