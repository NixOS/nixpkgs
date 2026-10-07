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
  libcanberra-gtk3,
  libgee,
  libgtop,
  libnotify,
  libpeas2,
  libpulseaudio,
  libuuid,
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
  xdg-desktop-portal,
}:

let
  pythonEnv = python3.withPackages (
    pp: with pp; [
      dbus-python
      psutil
      pygobject3
      systemd-python
    ]
  );
in
stdenv.mkDerivation (finalAttrs: {
  pname = "budgie-desktop";
  version = "10.10.3";

  src = fetchFromGitHub {
    owner = "BuddiesOfBudgie";
    repo = "budgie-desktop";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-WEUFB3Q3RQZfsZd/xUn6qmGXPM/dR3sUe6pBnJG3vIk=";
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
    meson
    ninja
    pkg-config
    python3
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
    libcanberra-gtk3
    libgee
    libgtop
    libnotify
    libpulseaudio
    libuuid
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
    "-Dbudgie-session-libexecdir=${budgie-session}/libexec"
    "-Dgsd-libexecdir=${gnome-settings-daemon}/libexec"
    "-Dxdp-libexecdir=${xdg-desktop-portal}/libexec"
    "-Dwith-runtime-dependencies=false"
  ];

  postPatch = ''
    patchShebangs po/listUiFiles.py

    substituteInPlace src/session/budgie-desktop.in \
      --replace-fail "@bindir@/org.buddiesofbudgie.Services" "${lib.getExe budgie-desktop-services}"
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
