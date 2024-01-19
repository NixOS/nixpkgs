{ lib
, writeShellScript
, buildFHSEnv
, stdenvNoCC
, fetchurl
, autoPatchelfHook
, dpkg
, nss
, cacert
, alsa-lib
, libvorbis
, libdrm
, libGL
, wayland
, xkeyboard_config
, libthai
, libsForQt5
}:

let
  pname = "insync";
  # Find a binary from https://www.insynchq.com/downloads/linux#ubuntu.
  version = "3.8.6.50504";
  ubuntu-dist = "mantic_amd64";
  meta = with lib; {
    platforms = ["x86_64-linux"];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    maintainers = with maintainers; [ hellwolf ];
    homepage = "https://www.insynchq.com";
    description = "Google Drive sync and backup with multiple account support";
    longDescription = ''
     Insync is a commercial application that syncs your Drive files to your
     computer.  It has more advanced features than Google's official client
     such as multiple account support, Google Doc conversion, symlink support,
     and built in sharing.

     There is a 15-day free trial, and it is a paid application after that.

     Known bug(s):

     1) Currently the system try icon does not render correctly.
     2) libqtvirtualkeyboardplugin does not have necessary Qt library shipped from vendor.
    '';
    mainProgram = "insync";
  };

  insync-pkg = stdenvNoCC.mkDerivation {
    name = "${pname}-pkg-${version}";
    inherit version meta;

    src = fetchurl {
      url = "https://cdn.insynchq.com/builds/linux/insync_${version}-${ubuntu-dist}.deb";
      sha256 = "sha256-QfSfTJjMTWShQETlUQqXQTYT7mBNhmj0HHoT5bjF0o8=";
    };

    nativeBuildInputs = [
      dpkg
      autoPatchelfHook
      libsForQt5.qt5.wrapQtAppsHook
    ];

    buildInputs = [
      nss
      alsa-lib
      libvorbis
      libdrm
      libGL
      wayland
      libthai
      libsForQt5.qt5.qtvirtualkeyboard
    ];

    unpackPhase = ''
      dpkg-deb --fsys-tarfile $src | tar -x --no-same-permissions --no-same-owner
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out
      cp -R usr/* $out/

      runHook postInstall
    '';

    # NB! This did the trick, otherwise it segfaults! However I don't understand why!
    dontStrip = true;
  };

in buildFHSEnv {
  name = pname;
  inherit meta;

  targetPkgs = pkgs: with pkgs; [
    cacert
    libudev0-shim
    insync-pkg
  ];

  extraInstallCommands = ''
    cp -rsHf "${insync-pkg}"/share $out
  '';

  runScript = writeShellScript "insync-wrapper.sh" ''
    # xkb configuration needed: https://github.com/NixOS/nixpkgs/issues/236365
    export XKB_CONFIG_ROOT=${xkeyboard_config}/share/X11/xkb/

    # For debugging:
    # export QT_DEBUG_PLUGINS=1

    # This is a workaround for an unidentified issue:
    #
    # When bbwrap-ed insync is launched in daemon mode, lots of red-herring issues appear. Namely, certificate
    # not found issues.
    #
    # This workaround simply does not allow insync to be run in a daemon unless explictly doing so.
    if [ "$1" == start ]; then
        shift
        set -- start --no-daemon "$@"
    elif [ "$1" == start_daemon ]; then
        shift
        set -- start "$@"
    fi

    mkdir -p ~/.config/Insync
    LC_TIME=C exec /usr/lib/insync/insync "$@" &>>~/.config/Insync/out.txt
    '';

  # As intended by this bubble wrap, share as much namespaces as possible with user.
  unshareUser   = false;
  unshareIpc    = false;
  unsharePid    = false;
  unshareNet    = false;
  unshareUts    = false;
  unshareCgroup = false;

  dieWithParent = true;
}
