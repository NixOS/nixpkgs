{
  lib,
  stdenv,
  nixosTests,

  fetchurl,
  fetchFromGitHub,

  autoreconfHook,
  wrapGAppsHook3,

  makeWrapper,

  asciidoc,
  bash,
  pkg-config,
  procps,
  psmisc,
  util-linux,

  boost,
  cairo,
  espeak-classic,
  glib,
  gobject-introspection,
  groff,
  gst_all_1,
  gtk2,
  gtk3,
  gtksourceview4,
  hicolor-icon-theme,
  intltool,
  kmod,
  libGLU,
  libepoxy,
  libgpiod,
  libmodbus,
  libtirpc,
  libtool,
  libusb1,
  libx11,
  libxmu,
  mesa-demos,
  ncurses,
  pango,
  python3,
  qt5,
  readline,
  sound-theme-freedesktop,
  sysctl,
  systemd,
  tcl,
  tclPackages,
  tk,
  which,

  /*
    Whether to compile the user-space implementation for use on Linux with PREEMPT_RT. See
    https://linuxcnc.org/docs/html/code/building-linuxcnc.html#_building_for_run_in_place for more
    details.
  */
  enableUspace ? true,

  /*
    LinuxCNC uses a couple of executable files with the setuid bit set to elevate privileges. It
    itself checks if the setuid bit is set, and if it isn't, it degrades into POSIX non-realtime,
    but it does so on the file in the Nix store (as opposed to `argv[0]` for example). Thus,
    in order for POSIX realtime to work, this option puts symlinks in the derivation's $out
    (i.e. `/nix/store/*-linuxcnc/bin/rtapi_app`) which point to the runtime wrapper dir
    (`/run/wrappers/bin/`).

    This makes LinuxCNC work as intended, but only, if the required setuid wrappers are installed.
    Else, it won't work at all, as the symlinks point to non existent files. Thus the argument
    defaults to `false`, but has to be overriden to `true` for the LinuxCNC NixOS module.
  */
  enableSetuidWrapperRedirection ? false,

  /*
    Enable the cool QT GUIs such as DragonQT. However, this implicates the use of an old
    `ps.pyqtwebengine` which in term implicates the use of a CVE riddled `qtwebengine`.
  */
  enableQt ? false,
}:

let
  pythonEnv = (
    python3.withPackages (
      ps:
      with ps;
      [
        boost
        gst-python
        numpy
        opencv4
        pycairo
        pygobject3
        pyopengl
        tkinter
        xlib
        yapps
      ]
      ++ lib.lists.optionals enableQt [
        poppler-qt5
        pyqt5
        pyqtwebengine
        qscintilla
      ]
    )
  );
  boost_python = (
    boost.override {
      enablePython = true;
      python = pythonEnv;
    }
  );
in
stdenv.mkDerivation (finalAttrs: {
  pname = "linuxcnc";
  version = "2.9.8";

  src = fetchFromGitHub {
    owner = "LinuxCNC";
    repo = "linuxcnc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8QZg+K/ROa0Z+5xFWvsqGPjM0pu9k24t/MS2zw02iy0=";
  };

  strictDeps = true;
  nativeBuildInputs = [
    autoreconfHook
    wrapGAppsHook3

    makeWrapper

    asciidoc # required even without `--enable-build-documentation` for the man pages
    gobject-introspection
    groff
    intltool
    pkg-config
    procps
    psmisc
    pythonEnv
    util-linux
    which
  ]
  ++ lib.lists.optionals enableQt [
    qt5.wrapQtAppsHook
  ];

  buildInputs = [
    bash
    boost_python
    cairo
    espeak-classic
    glib
    gobject-introspection
    gst_all_1.gst-plugins-base # for the Gstreamer playbin factory
    gst_all_1.gstreamer
    gtk2
    gtk3
    gtksourceview4
    hicolor-icon-theme
    intltool
    kmod
    libGLU
    libepoxy
    libgpiod
    libmodbus
    libtirpc
    libtool
    libusb1
    libxmu
    mesa-demos
    ncurses
    pango
    psmisc
    pythonEnv
    readline
    sysctl
    systemd
    tcl
    tclPackages.blt
    tclPackages.bwidget
    tclPackages.tclx
    tk
    util-linux
  ]
  ++ lib.lists.optionals enableQt [
    qt5.qtbase
  ];

  # cd into ./src here instead of setting sourceRoot as the build process uses the original sourceRoot
  preAutoreconf = ''
    cd ./src
  '';

  patches = [
    ./fix-hardcoded-executable-paths.patch

    # TODO remove on the next release after 2.9.8
    # Make LinuxCNC wait until spindle is at-speed also when the speed was set to 0 via `M5`.
    # See https://github.com/LinuxCNC/linuxcnc/pull/4160 for context.
    ./backport-pr4160-to-2.9.8.patch

    # TODO remove on the next release after 2.9.8
    # Fixes `image-to-gcode.py` in lieu of modern numpy and tk
    (fetchurl {
      url = "https://github.com/LinuxCNC/linuxcnc/pull/4021.patch";
      hash = "sha256-eHh2AnpojMspmZOahg7Cp4VWUTz0kiHntliIXL2Rlnw=";
    })

    # TODO remove on the next release after 2.9.8
    # Fixes the PREEMPT_RT detection logic for more recent kernels (6.12 and later).
    # See https://github.com/LinuxCNC/linuxcnc/issues/3262 for context.
    (fetchurl {
      url = "https://github.com/LinuxCNC/linuxcnc/commit/6e3814c6d04d6cbb4f744c323ffe0250f0ff4c06.patch";
      hash = "sha256-8iG55vRFGPZ9iiV5dWlhPrgeUaA0sk42iNqXstLl3Sg=";
    })

    # TODO remove on the next release after 2.9.8
    # This patch fixes an amibguity in whether the current tool offset is actually applied or not.
    # See https://github.com/LinuxCNC/linuxcnc/pull/3996 for context.
    (fetchurl {
      url = "https://github.com/LinuxCNC/linuxcnc/commit/267094af33f3c5ec70c816f44f78e85b9776868d.patch";
      hash = "sha256-zRrHf3zXrw7xL2RcQM9QGIPPoQZtFrUnVaWGAbJH0jA=";
    })
  ];

  postPatch =
    # generic helper function to find and substitute strings
    # $1 is the search string, $2 its substitution
    ''
      findAndSubstitute(){
        grep --files-with-matches --null --binary-files=without-match --recursive -- "$1" . |
          while IFS= read -r -d "" FILE
          do
            substituteInPlace "$FILE" --replace-fail "$1" "$2"
          done
      }
    ''
    # fix all xdg sound paths
    + ''
      findAndSubstitute /usr/share/sounds/freedesktop/ \
        ${sound-theme-freedesktop}/share/sounds/freedesktop/
    ''
    # fix all share/linuxcnc paths in the scripts
    + ''
      findAndSubstitute /usr/share/linuxcnc "$out/share/linuxcnc"
    '';

  postAutoreconf = ''
    # We need -lncurses for -lreadline, but the configure script discards the env set by NixOS before checking for -lreadline
    substituteInPlace configure --replace-fail '-lreadline' '-lreadline -lncurses'

    substituteInPlace emc/usr_intf/pncconf/private_data.py \
      --replace-fail '/usr/share/themes' '${gtk3}/share/themes' \
      --replace-fail 'self.FIRMDIR = "/lib/firmware/hm2/"' \
      'self.FIRMDIR = os.environ.get("HM2_FIRMWARE_DIR", "${placeholder "out"}/firmware/hm2")'

    substituteInPlace hal/drivers/mesa-hostmot2/hm2_eth.c \
      --replace-fail '/sbin/iptables' '/run/current-system/sw/bin/iptables' \
      --replace-fail '/sbin/sysctl' '${sysctl}/bin/sysctl'

    substituteInPlace hal/drivers/mesa-hostmot2/hm2_rpspi.c \
      --replace-fail '/sbin/modprobe' '${kmod}/bin/modprobe' \
      --replace-fail '/sbin/rmmod' '${kmod}/bin/rmmod'

    substituteInPlace module_helper/module_helper.c \
      --replace-fail '/sbin/insmod' '${kmod}/bin/insmod' \
      --replace-fail '/sbin/rmmod' '${kmod}/bin/rmmod'
  '';

  configureFlags = [
    "--enable-build-documentation"
    "--exec-prefix=${placeholder "out"}"
    "--with-boost-libdir=${boost_python}/lib"
    "--with-boost-python=boost_python3"
    "--with-locale-dir=$(out)/locale"
    "--with-tclConfig=${tcl}/lib/tclConfig.sh"
    "--with-tkConfig=${tk}/lib/tkConfig.sh"
    # WARNING: The LinuxCNC binary you are building may not be distributable due to a license
    # incompatibility with LinuxCNC (some portions GPL-2 only) and Readline version 6 and greater
    # (GPL-3 or later).
    "--enable-non-distributable=yes"
  ]
  ++ lib.optional enableUspace "--with-realtime=uspace";

  __structuredAttrs = true;
  hardeningDisable = [ "all" ];
  enableParalellBuilding = true;

  installTargets = "install install-menu";

  preInstall = ''
    # Stop the Makefile attempting to set ownship+perms, it fails anyhow due to lack of root
    sed -i -e 's/chown.*//' -e 's/-o root//g' -e 's/-m [0-9]\+//g' Makefile
  '';

  installFlags = [
    "DESTDIR=${placeholder "out"}"
    "SITEPY=${placeholder "out"}/${pythonEnv.sitePackages}"
  ];

  # for some installabales, the `--prefix` configure flag and `DESTDIR` makeflag are concatenated.
  postInstall = ''
    cp --archive --link --update=none-fail -- "$out$out/"* "$out/"
    rm --recursive -- "$out/${builtins.storeDir}"
  '';

  dontCheckForBrokenSymlinks = true;

  # For full POSIX realt-time support, these executables need to be renamed to ${filename}-nosetuid.
  # They then will become target programs for setuid wrappers.
  setuidApps = [
    "rtapi_app"
    "linuxcnc_module_helper"
  ]
  ++ lib.lists.optionals (!enableUspace) [
    "pci_read"
    "pci_write"
  ];

  dontWrapGApps = true;
  dontWrapQtApps = true;

  preFixup =
    let
      inherit (lib.strings) concatMapStringsSep escapeShellArgs optionalString;

      ldLibraryPath = lib.makeLibraryPath [ libx11 ];
      path = lib.makeBinPath [
        (placeholder "out")
        espeak-classic
        mesa-demos
        pythonEnv # for pyrcc5
        tk
      ];
      pythonPath = "${pythonEnv}/${pythonEnv.sitePackages}:$out/${pythonEnv.sitePackages}";
      tclLibPath = lib.strings.concatStringsSep " " [
        ((placeholder "out") + "/lib/tcltk")
        (tclPackages.tk + "/lib/" + tclPackages.tk.libPrefix)
        (tclPackages.bwidget + "/lib/" + tclPackages.bwidget.pname + tclPackages.bwidget.version)
        (
          tclPackages.tclx
          + "/lib/"
          + tclPackages.tclx.pname
          + (lib.versions.majorMinor tclPackages.tclx.version)
        )
        (
          tclPackages.blt
          + "/lib/"
          + tclPackages.blt.pname
          + (lib.versions.majorMinor tclPackages.blt.version)
        )
      ];
    in
    # wrapp all but the setuid-apps
    # TODO remove EMC2_HOME var, it will be deprecated
    ''
      echo "${tclLibPath}"
      find "$out/bin" -type f ! \( ${
        concatMapStringsSep " -o " (f: "-name " + f) finalAttrs.setuidApps
      } \) -print0 |
        while IFS= read -r -d "" EXECUTABLE
        do
          wrapProgram "$EXECUTABLE" \
            --prefix LD_LIBRARY_PATH : ${ldLibraryPath} \
            --prefix PATH : ${path} \
            --prefix PYTHONPATH : "${pythonPath}" \
            --prefix TCLLIBPATH ' ' "${tclLibPath}" \
            --set EMC2_HOME "$out" \
            --set LINUXCNC_HOME "$out" \
            "''${gappsWrapperArgs[@]}" ${optionalString enableQt ''"''${qtWrapperArgs[@]}"''}
        done
    ''
    # rename the setuid-apps
    + lib.strings.optionalString enableSetuidWrapperRedirection ''
      pushd -- "$out/bin/"
      for executable in ${escapeShellArgs finalAttrs.setuidApps}
      do
        mv -- "$executable" "$executable-nosetuid"
        ln -s "/run/wrappers/bin/$executable" ./
      done
      popd
    ''
    # fix desktop item
    + ''
      mv -- "$out/usr/share/applications" "$out/share"
      mkdir -p -- "$out/share/icons"
      ln -rs "$out/share/linuxcnc/linuxcncicon.png" "$out/share/icons/"
    '';

  passthru = {
    inherit pythonEnv;
    inherit (finalAttrs) setuidApps;
    tests.nixos-module = nixosTests.linuxcnc;
  };

  meta = {
    mainProgram = "linuxcnc";
    homepage = "https://linuxcnc.org/";
    license = lib.licenses.gpl2Only // {
      # There is a conflict, as LinuxCNC (itself GPL-2) links with the GPL-3 or later `readline`.
      redistributable = false;
    };
    platforms = lib.platforms.linux;
  };
})
