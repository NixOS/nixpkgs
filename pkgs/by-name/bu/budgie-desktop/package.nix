{
  lib,
  stdenv,
  fetchFromGitHub,
  accountsservice,
  alsa-lib,
  budgie-screensaver,
  docbook-xsl-nons,
  glib,
  gnome-desktop,
  gnome-settings-daemon,
  gobject-introspection,
  graphene,
  gst_all_1,
  gtk-doc,
  gtk3,
  ibus,
  intltool,
  libcanberra-gtk3,
  libgee,
  libGL,
  libgudev,
  libnotify,
  libpeas2,
  libpulseaudio,
  libuuid,
  libwacom,
  libwnck,
  magpie,
  libgbm,
  meson,
  mutter,
  ninja,
  nix-update-script,
  nixosTests,
  pkg-config,
  polkit,
  sassc,
  testers,
  udev,
  upower,
  vala,
  validatePkgConfig,
  xfce,
  wrapGAppsHook3,
  zenity,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "budgie-desktop";
  version = "10.9.4";

  src = fetchFromGitHub {
    owner = "BuddiesOfBudgie";
    repo = "budgie-desktop";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-e1kkmzSYX8TwiY0IIZYIK/FgMbZ/8PqkUn8pk3CcXHU=";
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
    vala
    validatePkgConfig
    wrapGAppsHook3
  ];

  buildInputs = [
    accountsservice
    alsa-lib
    budgie-screensaver
    glib
    gnome-desktop
    gnome-settings-daemon
    mutter
    zenity
    graphene
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gtk3
    ibus
    libcanberra-gtk3
    libgee
    libGL
    libgudev
    libnotify
    libpulseaudio
    libuuid
    libwacom
    libwnck
    magpie
    libgbm
    polkit
    sassc
    udev
    upower
    xfce.libxfce4windowing
  ];

  propagatedBuildInputs = [
    # budgie-1.0.pc, budgie-raven-plugin-1.0.pc
    libpeas2
  ];

  mesonFlags = [
    # FIXME: The meson option name is confusing
    # https://github.com/BuddiesOfBudgie/budgie-desktop/pull/739#discussion_r2359421711
    "-Dbsd-libexecdir=${gnome-settings-daemon}/libexec"
  ];

  passthru = {
    providedSessions = [ "budgie-desktop" ];

    tests = {
      inherit (nixosTests) budgie;
      pkg-config = testers.hasPkgConfigModules { package = finalAttrs.finalPackage; };
    };

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
      "budgie-2.0"
      "budgie-raven-plugin-2.0"
      "budgie-theme-1.0"
    ];
  };
})
