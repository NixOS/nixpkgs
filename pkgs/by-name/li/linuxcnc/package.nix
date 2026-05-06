{
  lib,
  stdenv,

  fetchFromGitHub,

  autoreconfHook,
  wrapGAppsHook3,
  wrapGAppsHook4,

  makeWrapper,

  asciidoc,
  bash,
  intltool,
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
  kmod,
  libGLU,
  libxmu,
  libepoxy,
  libmodbus,
  libtirpc,
  libtool,
  libusb1,
  libx11,
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

  /*
    Whether to compile the user-space implementation for use on Linux with PREEMPT_RT. See
    https://linuxcnc.org/docs/html/code/building-linuxcnc.html#_building_for_run_in_place for more
    details.
  */
  uspace ? true,

  /*
    LinuxCNC uses a couple of executable files with the setuid bit set to elevate privileges.
    It itself checks if the setuid bit is set, and if it isn't, it degrades into POSIX
    non-realtime, but it does so on the file in the Nix store (as opposed to `argv[0]` for
    example. Thus, in order for POSIX realtime to work, this option puts symlinks in the derivation's
    $out (i.e. `/nix/store/*-linuxcnc/bin/rtapi_app`) which point to the runtime wrapper dir
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
      [
        ps.boost
        ps.gst-python
        ps.numpy
        ps.opencv4
        ps.pycairo
        ps.pygobject3
        ps.pyopengl
        ps.tkinter
        ps.xlib
        ps.yapps
      ]
      ++ lib.lists.optionals enableQt [
        ps.poppler-qt5
        ps.pyqt5
        ps.pyqtwebengine
        ps.qscintilla
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
  __structuredAttrs = true;
  hardeningDisable = [ "all" ];
  enableParalellBuilding = true;
  pname = "linuxcnc";
  version = "2.9.8";

  src = fetchFromGitHub {
    owner = "LinuxCNC";
    repo = "linuxcnc";
    rev = "v${finalAttrs.version}";
    hash = "sha256-8QZg+K/ROa0Z+5xFWvsqGPjM0pu9k24t/MS2zw02iy0=";
  };

  strictDeps = true;
  nativeBuildInputs = [
    autoreconfHook
    wrapGAppsHook3
    wrapGAppsHook4

    makeWrapper

    asciidoc
    gobject-introspection
    groff
    intltool
    pkg-config
    procps
    psmisc
    pythonEnv
    util-linux
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
    libmodbus
    libtirpc
    libtool
    libusb1
    libxmu
    mesa-demos # previously glxinfo
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
      --replace-fail '/usr/share/themes' '${gtk3}/share/themes'

    substituteInPlace emc/usr_intf/pncconf/private_data.py \
      --replace-fail 'self.FIRMDIR = "/lib/firmware/hm2/"' \
      'self.FIRMDIR = os.environ.get("HM2_FIRMWARE_DIR", "${placeholder "out"}/firmware/hm2")'

    substituteInPlace hal/drivers/mesa-hostmot2/hm2_eth.c \
      --replace-fail '/sbin/iptables' '/run/current-system/sw/bin/iptables'

    substituteInPlace hal/drivers/mesa-hostmot2/hm2_eth.c \
      --replace-fail '/sbin/sysctl' '${sysctl}/bin/sysctl'

    substituteInPlace hal/drivers/mesa-hostmot2/hm2_rpspi.c \
      --replace-fail '/sbin/modprobe' '${kmod}/bin/modprobe'

    substituteInPlace hal/drivers/mesa-hostmot2/hm2_rpspi.c \
      --replace-fail '/sbin/rmmod' '${kmod}/bin/rmmod'

    substituteInPlace module_helper/module_helper.c \
      --replace-fail '/sbin/insmod' '${kmod}/bin/insmod'

    substituteInPlace module_helper/module_helper.c \
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
  ++ lib.lists.optional uspace "--with-realtime=uspace";

  installTargets = "install install-menu";

  enableParallelBuilding = true;

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
    rm --recursive -- "$out/nix" # TODO don't hardcode /nix as store path
  '';

  dontCheckForBrokenSymlinks = true;

  # For full POSIX realt-time support, these executables need to be renamed to ${filename}-nosetuid.
  # They then will become target programs for setuid wrappers.
  setuidApps = [
    "rtapi_app"
    "linuxcnc_module_helper"
  ]
  ++ lib.lists.optionals (!uspace) [
    "pci_read"
    "pci_write"
  ];

  dontWrapGApps = true;
  dontWrapQtApps = true;

  preFixup =
    let
      inherit (lib.strings) concatMapStringsSep escapeShellArgs optionalString;

      ldLibraryPath = lib.strings.makeLibraryPath [ libx11 ];
      path = lib.strings.makeBinPath [
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
      for EXECUTABLE in ${escapeShellArgs finalAttrs.setuidApps}
      do
        mv -- "$EXECUTABLE" "$EXECUTABLE-nosetuid"
        ln --symbolic -- "/run/wrappers/bin/$EXECUTABLE" ./
      done
      popd
    ''
    # fix desktop item
    + ''
      mv -- "$out/usr/share/applications" "$out/share"
      mkdir --parent -- "$out/share/icons"
      ln --relative --symbolic -- \
        "$out/share/linuxcnc/linuxcncicon.png" "$out/share/icons/"
    '';

  passthru = {
    inherit pythonEnv;
    inherit (finalAttrs) setuidApps;
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
