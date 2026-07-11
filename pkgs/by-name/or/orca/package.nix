{
  lib,
  stdenv,
  buildPackages,
  pkg-config,
  fetchurl,
  fetchpatch,
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
  gsettings-desktop-schemas,
  speechd-minimal,
  brltty,
  liblouis,
  gst_all_1,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "orca";
  version = "50.2";

  pyproject = false;

  src = fetchurl {
    url = "mirror://gnome/sources/orca/${lib.versions.major finalAttrs.version}/orca-${finalAttrs.version}.tar.xz";
    hash = "sha256-BxRCHN6OxLr0fxjktKErTlxKPP47FhVp4HD+A3cT/QQ=";
  };

  patches = [
    # Avoid running `cat` and `grep` subshells.
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/orca/-/commit/8f47283da2da7a7d34e769d9c129152decf632cb.patch";
      hash = "sha256-ts/ZCgEaTrnmMM1cUFJB2rDW9icMoi4jV34psD0IDCc=";
    })

    # Required for next patch to apply.
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/orca/-/commit/a7b10302b9ff9145a98cb3626f2488d15c558d3e.patch";
      hash = "sha256-lacy9vIyM3n84s+tbYvAUBKWCT+4nlI9uPVl7UPVS74=";
      includes = [
        "src/orca/orca_modifier_manager.py"
      ];
    })

    (replaceVars ./fix-paths.patch {
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

  meta = {
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
    maintainers = with lib.maintainers; [ berce ];
    teams = [ lib.teams.gnome ];
    license = lib.licenses.lgpl21;
    platforms = lib.platforms.linux;
  };
})
