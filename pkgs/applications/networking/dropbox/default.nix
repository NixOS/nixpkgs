{ stdenv, lib, buildFHSUserEnv, writeScript, makeDesktopItem }:

let platforms = [ "i686-linux" "x86_64-linux" ]; in

assert lib.elem stdenv.hostPlatform.system platforms;

# Dropbox client to bootstrap installation.
# The client is self-updating, so the actual version may be newer.
let
  version = "111.3.447";

  arch = {
    x86_64-linux = "x86_64";
    i686-linux   = "x86";
  }.${stdenv.hostPlatform.system};

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
    icon = "dropbox";
  };
in

buildFHSUserEnv {
  name = "dropbox";

  targetPkgs = pkgs: with pkgs; with xorg; [
    libICE libSM libX11 libXcomposite libXdamage libXext libXfixes libXrender
    libXxf86vm libxcb xkeyboardconfig
    curl dbus firefox-bin fontconfig freetype gcc glib gnutar libxml2 libxslt
    procps zlib mesa libxshmfence libpthreadstubs libappindicator
  ];

  extraInstallCommands = ''
    mkdir -p "$out/share/applications"
    cp "${desktopItem}/share/applications/"* $out/share/applications
  '';

  runScript = writeScript "install-and-start-dropbox" ''
    export BROWSER=firefox

    set -e

    do_install=
    if ! [ -d "$HOME/.dropbox-dist" ]; then
        do_install=1
    else
        installed_version=$(cat "$HOME/.dropbox-dist/VERSION")
        latest_version=$(printf "${version}\n$installed_version\n" | sort -rV | head -n 1)
        if [ "x$installed_version" != "x$latest_version" ]; then
            do_install=1
        fi
    fi

    if [ -n "$do_install" ]; then
        installer=$(mktemp)
        # Dropbox is not installed.
        # Download and unpack the client. If a newer version is available,
        # the client will update itself when run.
        curl '${installer}' >"$installer"
        pkill dropbox || true
        rm -fr "$HOME/.dropbox-dist"
        tar -C "$HOME" -x -z -f "$installer"
        rm "$installer"
    fi

    exec "$HOME/.dropbox-dist/dropboxd" "$@"
  '';

  meta = with lib; {
    description = "Online stored folders (daemon version)";
    homepage    = "http://www.dropbox.com/";
    license     = licenses.unfree;
    maintainers = with maintainers; [ ttuegel ];
    platforms   = [ "i686-linux" "x86_64-linux" ];
  };
}
