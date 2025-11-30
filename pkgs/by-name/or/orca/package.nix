{
  lib,
  stdenv,
  buildPackages,
  pkg-config,
  fetchurl,
  meson,
  ninja,
  wrapGAppsHook3,
  gobject-introspection,
  gettext,
  yelp-tools,
  itstool,
  python3,
  gtk3,
  gnome,
  replaceVars,
  at-spi2-atk,
  at-spi2-core,
  dbus,
  xkbcomp,
  procps,
  gnugrep,
  coreutils,
  gsettings-desktop-schemas,
  speechd-minimal,
  brltty,
  liblouis,
  gst_all_1,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "orca";
  version = "49.5";

  format = "other";

  src = fetchurl {
    url = "mirror://gnome/sources/orca/${lib.versions.major version}/orca-${version}.tar.xz";
    hash = "sha256-U99BVYMZ6XwehK1gSYmVegK10P9TFBkZDwWH6mslYDQ=";
  };

  patches = [
    (replaceVars ./fix-paths.patch {
      cat = "${coreutils}/bin/cat";
      grep = "${gnugrep}/bin/grep";
      pgrep = "${procps}/bin/pgrep";
      xkbcomp = "${xkbcomp}/bin/xkbcomp";
    })
  ];

  # needed for cross-compilation
  depsBuildBuild = [ pkg-config ];

  nativeBuildInputs = [
    # cross-compilation support requires the host environment's build time
    # to make the following buildPackages available.
    buildPackages.gtk3
    buildPackages.python3
    buildPackages.python3Packages.pygobject3
    meson
    ninja
    wrapGAppsHook3
    pkg-config
    gettext
    yelp-tools
    itstool
    gobject-introspection
  ];

  pythonPath = with python3.pkgs; [
    dasbus
    pygobject3
    dbus-python
    pyxdg
    brltty
    liblouis
    psutil
    speechd-minimal
    gst-python
    setproctitle
  ];

  strictDeps = false;

  buildInputs = [
    python3
    gtk3
    at-spi2-atk
    at-spi2-core
    dbus
    gsettings-desktop-schemas
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
  ];

  # Help GI find typelibs during Meson's configure step in cross builds
  preConfigure = lib.optionalString (stdenv.buildPlatform != stdenv.hostPlatform) ''
    export GI_TYPELIB_PATH=${buildPackages.gtk3}/lib/girepository-1.0''${GI_TYPELIB_PATH:+:$GI_TYPELIB_PATH}
  '';

  dontWrapGApps = true; # Prevent double wrapping

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
    substituteInPlace $out/lib/systemd/user/orca.service --replace-fail ExecStart=orca ExecStart=$out/bin/orca
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "orca";
    };
  };

  meta = with lib; {
    homepage = "https://orca.gnome.org/";
    changelog = "https://gitlab.gnome.org/GNOME/orca/-/blob/main/NEWS";
    description = "Screen reader";
    mainProgram = "orca";
    longDescription = ''
      A free, open source, flexible and extensible screen reader that provides
      access to the graphical desktop via speech and refreshable braille.
      It works with applications and toolkits that support the Assistive
      Technology Service Provider Interface (AT-SPI). That includes the GNOME
      GTK toolkit, the Java platform's Swing toolkit, LibreOffice, Gecko, and
      WebKitGtk. AT-SPI support for the KDE Qt toolkit is being pursued.

      Needs `services.gnome.at-spi2-core.enable = true;` in `configuration.nix`.
    '';
    maintainers = with maintainers; [ berce ];
    teams = [ teams.gnome ];
    license = licenses.lgpl21;
    platforms = platforms.linux;
  };
}
