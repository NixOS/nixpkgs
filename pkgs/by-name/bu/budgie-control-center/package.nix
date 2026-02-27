{
  lib,
  stdenv,
  fetchFromGitHub,
  replaceVars,
  accountsservice,
  budgie-desktop,
  cheese,
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
  gnome-settings-daemon,
  gsettings-desktop-schemas,
  gsound,
  gtk3,
  ibus,
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
  udisks,
  upower,
  wdisplays,
  webp-pixbuf-loader,
  wrapGAppsHook3,
  enableSshSocket ? false,
}:

let
  introduction_list = (
    replaceVars ./introduction.list {
      budgie_desktop = budgie-desktop;
      inherit wdisplays;
    }
  );
in
stdenv.mkDerivation (finalAttrs: {
  pname = "budgie-control-center";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "BuddiesOfBudgie";
    repo = "budgie-control-center";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-sdAzReZVAZ5omLOhly/l3buiw01eem+k9+3RbVPzS2g=";
  };

  patches = [
    (replaceVars ./paths.patch {
      budgie_desktop = budgie-desktop;
      gcm = gnome-color-manager;
      inherit
        cups
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
    colord
    colord-gtk
    fontconfig
    gcr
    gdk-pixbuf
    glib
    glib-networking
    gnome-desktop
    gst_all_1.gstreamer
    cheese
    gnome-bluetooth_1_0
    gnome-settings-daemon
    gsettings-desktop-schemas
    gsound
    gtk3
    ibus
    libepoxy
    libgtop
    libgudev
    libhandy
    libkrb5
    libnma
    libpulseaudio
    libpwquality
    libsecret
    libwacom
    libxml2
    modemmanager
    networkmanager
    polkit
    samba
    udisks
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

    install -Dm644 ${introduction_list} $out/share/budgie-control-center/introduction/introduction.list
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      # Sound theme
      --prefix XDG_DATA_DIRS : "${budgie-desktop}/share"
      # Thumbnailers (for setting user profile pictures)
      --prefix XDG_DATA_DIRS : "${gdk-pixbuf}/share"
      --prefix XDG_DATA_DIRS : "${librsvg}/share"
    )
  '';

  separateDebugInfo = true;

  passthru = {
    tests.version = testers.testVersion { package = finalAttrs.finalPackage; };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Fork of GNOME Control Center for the Budgie 10 Series";
    homepage = "https://github.com/BuddiesOfBudgie/budgie-control-center";
    changelog = "https://github.com/BuddiesOfBudgie/budgie-control-center/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl2Plus;
    teams = [ lib.teams.budgie ];
    mainProgram = "budgie-control-center";
    platforms = lib.platforms.linux;
  };
})
