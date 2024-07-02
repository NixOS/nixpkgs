{ alsa-lib
, autoPatchelfHook
, buildFHSEnv
, dbus
, elfutils
, expat
, extraEnv ? { }
, fetchurl
, glib
, glibc
, lib
, libGL
, libapparmor
, libbsd
, libedit
, libffi_3_3
, libgcrypt
, libz
, makeShellWrapper
, sqlite
, squashfsTools
, stdenv
, tcp_wrappers
, udev
, waylandpp
, writeShellScript
, xkeyboard_config
, xorg
, xz
, zstd
}:
let
  pname = "plex-desktop";
  version = "1.95.3";
  rev = "68";
  meta = {
    homepage = "https://plex.tv/";
    description = "Streaming media player for Plex";
    longDescription = ''
      Plex for Linux is your client for playback on the Linux
      desktop. It features the point and click interface you see in your browser
      but uses a more powerful playback engine as well as
      some other advance features.
    '';
    maintainers = with lib.maintainers; [ detroyejr ];
    license = lib.licenses.unfree;
    platforms = [ "x86_64-linux" ];
    mainProgram = "plex-desktop";
  };
  plex-desktop = stdenv.mkDerivation {
    inherit pname version meta;

    src = fetchurl {
      url = "https://api.snapcraft.io/api/v1/snaps/download/qc6MFRM433ZhI1XjVzErdHivhSOhlpf0_${rev}.snap";
      hash = "sha512-lz1lJspSgrit1IxTAFpdDZ2y2s8Udsd4veWAb7uTvAI2GVLQDsQpDPnUpnD2Mr0/SnayGPwMSC6ESpgDXfUzvg==";
    };

    buildInputs = [
      alsa-lib
      autoPatchelfHook
      dbus
      elfutils
      expat
      glib
      glibc
      libGL
      libapparmor
      libbsd
      libedit
      libffi_3_3
      libgcrypt
      libz
      makeShellWrapper
      sqlite
      squashfsTools
      stdenv.cc.cc
      tcp_wrappers
      udev
      waylandpp
      xorg.libXinerama
      xz
      zstd
    ];

    nativeBuildInputs = [
      autoPatchelfHook
    ];

    unpackPhase = ''
      runHook preUnpack
      ${squashfsTools}/bin/unsquashfs "$src"
      cd squashfs-root
      runHook postUnpack
    '';

    dontWrapQtApps = true;

    installPhase =
      ''
        runHook preInstall

        cp -r . $out

        ln -s ${libedit}/lib/libedit.so.0 $out/lib/libedit.so.2
        rm $out/usr/lib/x86_64-linux-gnu/libasound.so.2
        ln -s ${alsa-lib}/lib/libasound.so.2 $out/usr/lib/x86_64-linux-gnu/libasound.so.2
        rm $out/usr/lib/x86_64-linux-gnu/libasound.so.2.0.0
        ln -s ${alsa-lib}/lib/libasound.so.2.0.0 $out/usr/lib/x86_64-linux-gnu/libasound.so.2.0.0

        runHook postInstall
      '';
  };
in
buildFHSEnv {
    name = "${pname}";
    targetPkgs = pkgs: [ plex-desktop xkeyboard_config ];

    extraInstallCommands = ''
      mkdir -p $out/share/applications $out/share/icons/hicolor/scalable/apps
      install -m 444 -D ${plex-desktop}/meta/gui/plex-desktop.desktop $out/share/applications/plex-desktop.desktop
      substituteInPlace $out/share/applications/${pname}.desktop \
        --replace-warn \
        'Icon=''${SNAP}/meta/gui/icon.png' \
        'Icon=${plex-desktop}/meta/gui/icon.png'
    '';

    runScript = writeShellScript "Plex.sh" ''
      export LD_LIBRARY_PATH=${plex-desktop}:${plex-desktop}/lib
      export LIBGL_DRIVERS_PATH=${plex-desktop}/usr/lib/x86_64-linux-gnu/dri
      export QT_QPA_PLATFORM=xcb
      export DISABLE_WAYLAND=1
      export ${lib.toShellVars extraEnv}
      ${plex-desktop}/Plex.sh
  '';
}
