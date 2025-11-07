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
    tag = "v${finalAttrs.version}";
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

    # Resolve vala 0.56.18 compact class inheritance removal
    # https://github.com/BuddiesOfBudgie/budgie-desktop/issues/679
    (fetchpatch {
      url = "https://github.com/BuddiesOfBudgie/budgie-desktop/commit/46c83b1265b4230668da472d9ef6926941678418.patch";
      hash = "sha256-qnA8iBEctZbE86qIPudI1vMbgFy4xDWrxxej517ORws=";
    })

    # Add override for overlay-key to prevent crash with mutter-common v48-rc
    # https://github.com/BuddiesOfBudgie/budgie-desktop/pull/683
    (fetchpatch {
      url = "https://github.com/BuddiesOfBudgie/budgie-desktop/commit/c24091bb424abe99ebcdd33eedd37068f735ad2a.patch";
      hash = "sha256-4WEkscftOGZmzH7imMTmcTDPH6eHMeEhgto+R5NNlh0=";
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
    teams = [ lib.teams.budgie ];
    platforms = lib.platforms.linux;
    pkgConfigModules = [
      "budgie-1.0"
      "budgie-raven-plugin-1.0"
      "budgie-theme-1.0"
    ];
  };
})
