{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  accountsservice,
  alsa-lib,
  budgie-screensaver,
  docbook-xsl-nons,
  glib,
  gnome-desktop,
  gnome-settings-daemon,
  graphene,
  gst_all_1,
  gtk-doc,
  gtk3,
  ibus,
  intltool,
  libcanberra-gtk3,
  libgee,
  libGL,
  libnotify,
  libpeas,
  libpulseaudio,
  libuuid,
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
  upower,
  vala,
  validatePkgConfig,
  xfce,
  wrapGAppsHook3,
  zenity,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "budgie-desktop";
  version = "10.9.2";

  src = fetchFromGitHub {
    owner = "BuddiesOfBudgie";
    repo = "budgie-desktop";
    rev = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-lDsQlUAa79gnM8wC5pwyquvFyEiayH4W4gD/uyC5Koo=";
  };

  outputs = [
    "out"
    "dev"
    "man"
  ];

  patches = [
    ./plugins.patch

    # Adapt to libxfce4windowing v4.19.8
    # https://github.com/BuddiesOfBudgie/budgie-desktop/pull/627
    (fetchpatch {
      url = "https://github.com/BuddiesOfBudgie/budgie-desktop/commit/ba8170b4f3108f9de28331b6a98a9d92bb0ed4de.patch";
      hash = "sha256-T//1/NmaV81j0jiIYK7vEp8sgKCgF2i10D+Rk9qAAeE=";
    })
  ];

  nativeBuildInputs = [
    docbook-xsl-nons
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
    libnotify
    libpulseaudio
    libuuid
    libwnck
    magpie
    libgbm
    polkit
    sassc
    upower
    xfce.libxfce4windowing
  ];

  propagatedBuildInputs = [
    # budgie-1.0.pc, budgie-raven-plugin-1.0.pc
    libpeas
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
    maintainers = lib.teams.budgie.members;
    platforms = lib.platforms.linux;
    pkgConfigModules = [
      "budgie-1.0"
      "budgie-raven-plugin-1.0"
      "budgie-theme-1.0"
    ];
  };
})
