{ lib
, writeShellScript
, buildFHSEnvBubblewrap
, stdenvNoCC
, fetchurl
, autoPatchelfHook
, dpkg
, nss
, libvorbis
, libdrm
, libGL
, wayland
, xkeyboard_config
, libthai
}:

let
  pname = "insync";
  version = "3.8.6.50504";
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
  };

  insync-pkg = stdenvNoCC.mkDerivation {
    name = "${pname}-pkg-${version}";
    inherit version meta;

    src = fetchurl {
      # Find a binary from https://www.insynchq.com/downloads/linux#ubuntu.
      url = "https://cdn.insynchq.com/builds/linux/insync_${version}-lunar_amd64.deb";
      sha256 = "sha256-BxTFtQ1rAsOuhKnH5vsl3zkM7WOd+vjA4LKZGxl4jk0=";
    };

    buildInputs = [
      nss
      libvorbis
      libdrm
      libGL
      wayland
      libthai
    ];

    nativeBuildInputs = [ autoPatchelfHook dpkg ];

    unpackPhase = ''
      dpkg-deb --fsys-tarfile $src | tar -x --no-same-permissions --no-same-owner
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out
      cp -R usr/* $out/

      # use system glibc
      rm $out/lib/insync/{libgcc_s.so.1,libstdc++.so.6}

      # remove badly packaged plugins
      rm $out/lib/insync/PySide2/plugins/platforminputcontexts/libqtvirtualkeyboardplugin.so

      # remove the unused vendor wrapper
      rm $out/bin/insync

      runHook postInstall
    '';

    # NB! This did the trick, otherwise it segfaults! However I don't understand why!
    dontStrip = true;
  };

in buildFHSEnvBubblewrap {
  name = pname;
  inherit meta;

  targetPkgs = pkgs: with pkgs; [
    insync-pkg
    libudev0-shim
  ];

  runScript = writeShellScript "insync-wrapper.sh" ''
    # QT_STYLE_OVERRIDE was used to suppress a QT warning, it should have no actual effect for this binary.
    echo Unsetting QT_STYLE_OVERRIDE=$QT_STYLE_OVERRIDE
    echo Unsetting QT_QPA_PLATFORMTHEME=$QT_QPA_PLATFORMTHEME
    unset QT_STYLE_OVERRIDE
    unset QPA_PLATFORMTHEME

    # xkb configuration needed: https://github.com/NixOS/nixpkgs/issues/236365
    export XKB_CONFIG_ROOT=${xkeyboard_config}/share/X11/xkb/
    echo XKB_CONFIG_ROOT=$XKB_CONFIG_ROOT

    # For debuging:
    # export QT_DEBUG_PLUGINS=1
    # find -L /usr/share -name "*insync*"

    exec /usr/lib/insync/insync "$@"
    '';

  # As intended by this bubble wrap, share as much namespaces as possible with user.
  unshareUser   = false;
  unshareIpc    = false;
  unsharePid    = false;
  unshareNet    = false;
  unshareUts    = false;
  unshareCgroup = false;
  # Since "insync start" command starts a daemon, this daemon should die with it.
  dieWithParent = false;
}
