{
  lib,
  stdenv,
  fetchFromGitHub,
  substituteAll,
  accountsservice,
  adwaita-icon-theme,
  budgie-desktop,
  cheese,
  clutter,
  clutter-gtk,
  colord,
  colord-gtk,
  cups,
  docbook-xsl-nons,
  fontconfig,
  gcr,
  gdk-pixbuf,
  gettext,
  glib,
  glib-networking,
  glibc,
  gnome,
  gst_all_1,
  gnome-bluetooth_1_0,
  gnome-color-manager,
  gnome-desktop,
  gnome-remote-desktop,
  gnome-settings-daemon,
  gnome-user-share,
  gsettings-desktop-schemas,
  gsound,
  gtk3,
  ibus,
  libcanberra-gtk3,
  libepoxy,
  libgnomekbd,
  libgtop,
  libgudev,
  libhandy,
  libkrb5,
  libnma,
  libpulseaudio,
  libpwquality,
  librsvg,
  libsecret,
  libwacom,
  libxml2,
  libxslt,
  meson,
  modemmanager,
  mutter,
  networkmanager,
  networkmanagerapplet,
  ninja,
  nix-update-script,
  pkg-config,
  polkit,
  samba,
  shadow,
  shared-mime-info,
  testers,
  tzdata,
  udisks2,
  upower,
  webp-pixbuf-loader,
  wrapGAppsHook3,
  enableSshSocket ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "budgie-control-center";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "BuddiesOfBudgie";
    repo = "budgie-control-center";
    rev = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-W5PF7BPdQdg/7xJ4J+fEnuDdpoG/lyhX56RDnX2DXoY=";
  };

  patches = [
    (substituteAll {
      src = ./paths.patch;
      budgie_desktop = budgie-desktop;
      gcm = gnome-color-manager;
      inherit
        cups
        glibc
        libgnomekbd
        shadow
        ;
      inherit networkmanagerapplet tzdata;
    })
  ];

  nativeBuildInputs = [
    docbook-xsl-nons
    gettext
    libxslt
    meson
    ninja
    pkg-config
    shared-mime-info
    wrapGAppsHook3
  ];

  buildInputs = [
    accountsservice
    clutter
    clutter-gtk
    colord
    colord-gtk
    fontconfig
    gcr
    gdk-pixbuf
    glib
    glib-networking
    gnome-desktop
    gst_all_1.gstreamer
    adwaita-icon-theme
    cheese
    gnome-bluetooth_1_0
    gnome-remote-desktop
    gnome-settings-daemon
    gnome-user-share
    mutter
    gsettings-desktop-schemas
    gsound
    gtk3
    ibus
    libcanberra-gtk3
    libepoxy
    libgtop
    libgudev
    libhandy
    libkrb5
    libnma
    libpulseaudio
    libpwquality
    librsvg
    libsecret
    libwacom
    libxml2
    modemmanager
    networkmanager
    polkit
    samba
    udisks2
    upower
  ];

  mesonFlags = [ (lib.mesonBool "ssh" enableSshSocket) ];

  preConfigure = ''
    # For ITS rules
    addToSearchPath "XDG_DATA_DIRS" "${polkit.out}/share"
  '';

  postInstall = ''
    # Pull in WebP support for gnome-backgrounds.
    # In postInstall to run before gappsWrapperArgsHook.
    export GDK_PIXBUF_MODULE_FILE="${
      gnome._gdkPixbufCacheBuilder_DO_NOT_USE {
        extraLoaders = [
          librsvg
          webp-pixbuf-loader
        ];
      }
    }"
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      # Sound theme
      --prefix XDG_DATA_DIRS : "${budgie-desktop}/share"
      # Thumbnailers (for setting user profile pictures)
      --prefix XDG_DATA_DIRS : "${gdk-pixbuf}/share"
      --prefix XDG_DATA_DIRS : "${librsvg}/share"
      # WM keyboard shortcuts
      --prefix XDG_DATA_DIRS : "${mutter}/share"
    )
  '';

  separateDebugInfo = true;

  # Fix GCC 14 build.
  # cc-display-panel.c:962:41: error: passing argument 1 of 'gtk_widget_set_sensitive'
  # from incompatible pointer type [-Wincompatible-pointer-types]
  env.NIX_CFLAGS_COMPILE = "-Wno-error=incompatible-pointer-types";

  passthru = {
    tests.version = testers.testVersion { package = finalAttrs.finalPackage; };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Fork of GNOME Control Center for the Budgie 10 Series";
    homepage = "https://github.com/BuddiesOfBudgie/budgie-control-center";
    changelog = "https://github.com/BuddiesOfBudgie/budgie-control-center/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl2Plus;
    maintainers = lib.teams.budgie.members;
    mainProgram = "budgie-control-center";
    platforms = lib.platforms.linux;
  };
})
