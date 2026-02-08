{
  lib,
  stdenv,
  fetchFromGitHub,
  accountsservice,
  alsa-lib,
  budgie-desktop-services,
  budgie-session,
  docbook-xsl-nons,
  glib,
  gnome-desktop,
  gnome-settings-daemon,
  gobject-introspection,
  gst_all_1,
  gtk-doc,
  gtk3,
  gtk-layer-shell,
  ibus,
  intltool,
  libcanberra-gtk3,
  libgee,
  libnotify,
  libpeas2,
  libpulseaudio,
  libuuid,
  libwacom,
  libwnck,
  libxfce4windowing,
  meson,
  mutter,
  ninja,
  nix-update-script,
  pkg-config,
  python3,
  sassc,
  testers,
  upower,
  vala,
  validatePkgConfig,
  wrapGAppsHook3,
}:

let
  pythonEnv = python3.withPackages (
    pp: with pp; [
      psutil
      pygobject3
      systemd-python
    ]
  );
in
stdenv.mkDerivation (finalAttrs: {
  pname = "budgie-desktop";
  version = "10.10.1";

  src = fetchFromGitHub {
    owner = "BuddiesOfBudgie";
    repo = "budgie-desktop";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-6SRnub0FMRE9AcHwsnYH4WMdG2kqEpl5dfHy56FwrGU=";
  };

  outputs = [
    "out"
    "dev"
    "man"
  ];

  patches = [
    ./plugins.patch
  ];

  nativeBuildInputs = [
    docbook-xsl-nons
    gobject-introspection
    gtk-doc
    intltool
    meson
    ninja
    pkg-config
    sassc
    vala
    validatePkgConfig
    wrapGAppsHook3
  ];

  buildInputs = [
    accountsservice
    alsa-lib
    glib
    gnome-desktop
    gnome-settings-daemon
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gtk3
    gtk-layer-shell
    ibus
    libcanberra-gtk3
    libgee
    libnotify
    libpulseaudio
    libuuid
    libwacom
    libwnck
    libxfce4windowing
    mutter # org.gnome.mutter.keybindings
    pythonEnv
    upower
  ];

  propagatedBuildInputs = [
    # budgie-3.0.pc, budgie-raven-plugin-3.0.pc
    libpeas2
  ];

  mesonFlags = [
    "-Dgsd-libexecdir=${gnome-settings-daemon}/libexec"
    "-Dwith-runtime-dependencies=false"
  ];

  postPatch = ''
    substituteInPlace src/session/budgie-desktop.in \
      --replace-fail "@bindir@/org.buddiesofbudgie.Services" "${lib.getExe budgie-desktop-services}" \
      --replace-fail "@gsd_libexecdir@/budgie-session-compositor-ready" "${budgie-session}/libexec/budgie-session-compositor-ready"

    chmod +x src/bridges/labwc/labwc_bridge.py
    substituteInPlace src/bridges/labwc/org.buddiesofbudgie.labwc-bridge.desktop.in \
      --replace-fail "Exec=python3 @libexecdir@/labwc_bridge.py" "Exec=@libexecdir@/labwc_bridge.py"
  '';

  passthru = {
    providedSessions = [ "budgie-desktop" ];
    tests.pkg-config = testers.hasPkgConfigModules { package = finalAttrs.finalPackage; };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Feature-rich, modern desktop designed to keep out the way of the user";
    homepage = "https://github.com/BuddiesOfBudgie/budgie-desktop";
    changelog = "https://github.com/BuddiesOfBudgie/budgie-desktop/releases/tag/v${finalAttrs.version}";
    license = with lib.licenses; [
      gpl2Plus
      lgpl21Plus
      cc-by-sa-30
    ];
    teams = [ lib.teams.budgie ];
    platforms = lib.platforms.linux;
    pkgConfigModules = [
      "budgie-3.0"
      "budgie-raven-plugin-3.0"
      "budgie-theme-1.0"
    ];
  };
})
