{
  lib,
  writeShellScript,
  buildFHSEnv,
  stdenvNoCC,
  fetchurl,
  autoPatchelfHook,
  dpkg,
  nss,
  alsa-lib,
  lz4,
  libgcrypt,
  xkeyboard_config,
  libthai,
  libsForQt5,
}:

let
  pname = "insync";
  # Find a binary from https://www.insynchq.com/downloads/linux
  version = "3.9.3.60019";
  ubuntu-dist = "trixie_amd64";
  insync-pkg = stdenvNoCC.mkDerivation {
    pname = "${pname}-pkg";
    inherit version;

    src = fetchurl rec {
      urls = [
        "https://cdn.insynchq.com/builds/linux/${version}/insync_${version}-${ubuntu-dist}.deb"
        "https://web.archive.org/web/20240731170718/${builtins.elemAt urls 0}"
      ];
      hash = "sha256-jexbcKU2N4esl6UHxre6C+0o8GD3DcdRJW2YYT5fUZs=";
    };

    nativeBuildInputs = [
      dpkg
      autoPatchelfHook
      libsForQt5.qt5.wrapQtAppsHook
    ];

    buildInputs = [
      alsa-lib
      nss
      lz4
      libgcrypt
      libthai
    ] ++ (with libsForQt5; [ qt5.qtvirtualkeyboard ]);

    installPhase = ''
      runHook preInstall

      # Remove unused plugins. This is based on missing libraries from the upstream package.
      rm -rf usr/lib/insync/PySide2/Qt/qml/

      mkdir -p $out
      cp -R usr/* $out/

      runHook postInstall
    '';

    # NB! This did the trick, otherwise it segfaults! However I don't understand why!
    dontStrip = true;
  };

in
buildFHSEnv {
  inherit pname version;

  targetPkgs =
    pkgs: with pkgs; [
      libudev0-shim
      insync-pkg
    ];

  extraInstallCommands = ''
    cp -rsHf "${insync-pkg}"/share $out/
  '';

  runScript = writeShellScript "insync-wrapper.sh" ''
    # xkb configuration needed: https://github.com/NixOS/nixpkgs/issues/236365
    export XKB_CONFIG_ROOT=${xkeyboard_config}/share/X11/xkb/

    # When using Ubuntu deb package, this might be needed for showing system tray icon.
    # export XDG_CURRENT_DESKTOP=Unity

    # For debugging:
    # export QT_DEBUG_PLUGINS=1

    exec /usr/lib/insync/insync "$@"
  '';

  # As intended by this bubble wrap, share as much namespaces as possible with user.
  unshareUser = false;
  unshareIpc = false;
  unsharePid = false;
  unshareNet = false;
  unshareUts = false;
  unshareCgroup = false;

  dieWithParent = true;

  meta = with lib; {
    platforms = [ "x86_64-linux" ];
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
    '';
    mainProgram = "insync";
  };
}
