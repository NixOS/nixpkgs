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
  version = "3.9.8.60034";
  web-archive-id = "20260301163242"; # upload via https://web.archive.org/save/
  debian-dist = "forky_amd64";
  insync-pkg = stdenvNoCC.mkDerivation {
    pname = "${pname}-pkg";
    inherit version;

    src = fetchurl rec {
      urls = [
        "https://cdn.insynchq.com/builds/linux/${version}/insync_${version}-${debian-dist}.deb"
        "https://web.archive.org/web/${web-archive-id}/${builtins.elemAt urls 0}"
      ];
      hash = "sha256-EeTp49so038/bEJ9P1ubPiSj7dKhGHtHmkV0ExMCmj0=";
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
    ]
    ++ (with libsForQt5; [ qt5.qtvirtualkeyboard ]);

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
      # Qt requires usr/share/icons/hicolor/index.theme file (provided by hicolor-icon-theme) to be
      # present to successfully find the system tray icons.
      hicolor-icon-theme
    ];

  extraInstallCommands = ''
    cp -rsHf "${insync-pkg}"/share $out/
  '';

  runScript = writeShellScript "insync-wrapper.sh" ''
    # xkb configuration needed: https://github.com/NixOS/nixpkgs/issues/236365
    export XKB_CONFIG_ROOT=${xkeyboard_config}/share/X11/xkb/

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

  meta = {
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ hellwolf ];
    homepage = "https://www.insynchq.com";
    description = "Google Drive sync and backup with multiple account support";
    longDescription = ''
      Insync is a commercial application that syncs your Drive files to your
      computer.  It has more advanced features than Google's official client
      such as multiple account support, Google Doc conversion, symlink support,
      and built in sharing.

      There is a 15-day free trial, and it is a paid application after that.
    '';
    mainProgram = "insync";
  };
}
