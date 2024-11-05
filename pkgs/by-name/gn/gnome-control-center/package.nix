{
  fetchurl,
  lib,
  stdenv,
  substituteAll,
  accountsservice,
  adwaita-icon-theme,
  colord,
  colord-gtk4,
  cups,
  dbus,
  docbook-xsl-nons,
  fontconfig,
  gdk-pixbuf,
  gettext,
  glib,
  glib-networking,
  gcr_4,
  glibc,
  gnome-bluetooth,
  gnome-color-manager,
  gnome-desktop,
  gnome-online-accounts,
  gnome-settings-daemon,
  gnome-tecla,
  gnome,
  gsettings-desktop-schemas,
  gsound,
  gst_all_1,
  gtk4,
  ibus,
  json-glib,
  libgtop,
  libgudev,
  libadwaita,
  libkrb5,
  libjxl,
  libpulseaudio,
  libpwquality,
  librsvg,
  webp-pixbuf-loader,
  libsecret,
  libsoup_3,
  libwacom,
  libXi,
  libxml2,
  libxslt,
  meson,
  modemmanager,
  mutter,
  networkmanager,
  networkmanagerapplet,
  libnma-gtk4,
  ninja,
  pkg-config,
  polkit,
  python3,
  samba,
  setxkbmap,
  shadow,
  shared-mime-info,
  sound-theme-freedesktop,
  tinysparql,
  localsearch,
  tzdata,
  udisks2,
  upower,
  libepoxy,
  gnome-user-share,
  gnome-remote-desktop,
  wrapGAppsHook4,
  xorgserver,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gnome-control-center";
  version = "47.0.1";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-control-center/${lib.versions.major finalAttrs.version}/gnome-control-center-${finalAttrs.version}.tar.xz";
    hash = "sha256-h+7fdDN7PGHfGaDcjCW1wpYp+1+Rm+w0y9CkscfbNWc=";
  };

  patches = [
    (substituteAll {
      src = ./paths.patch;
      gcm = gnome-color-manager;
      inherit glibc tzdata shadow;
      inherit cups networkmanagerapplet;
    })
  ];

  nativeBuildInputs = [
    docbook-xsl-nons
    gettext
    libxslt
    meson
    ninja
    pkg-config
    python3
    shared-mime-info
    wrapGAppsHook4
  ];

  buildInputs = [
    accountsservice
    adwaita-icon-theme
    colord
    colord-gtk4
    cups
    fontconfig
    gdk-pixbuf
    glib
    glib-networking
    gcr_4
    gnome-bluetooth
    gnome-desktop
    gnome-online-accounts
    gnome-remote-desktop # optional, sharing panel
    gnome-settings-daemon
    gnome-tecla
    gnome-user-share # optional, sharing panel
    gsettings-desktop-schemas
    gsound
    gtk4
    ibus
    json-glib
    libepoxy
    libgtop
    libgudev
    libadwaita
    libkrb5
    libnma-gtk4
    libpulseaudio
    libpwquality
    librsvg
    libsecret
    libsoup_3
    libwacom
    libXi
    libxml2
    modemmanager
    mutter # schemas for the keybindings
    networkmanager
    polkit
    samba
    tinysparql
    localsearch # for search locations dialog
    udisks2
    upower
    # For animations in Mouse panel.
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    # vp9alphadecodebin, observed from GST_DEBUG="*:3" warnings.
    # https://github.com/NixOS/nixpkgs/pull/333911#issuecomment-2409233470
    gst_all_1.gst-plugins-bad
  ];

  nativeCheckInputs = [
    dbus
    python3.pkgs.pygobject3 # for test-networkmanager-service.py
    python3.pkgs.python-dbusmock
    setxkbmap
    xorgserver # for Xvfb
  ];

  doCheck = true;

  preConfigure = ''
    # For ITS rules
    addToSearchPath "XDG_DATA_DIRS" "${polkit.out}/share"
  '';

  preCheck = ''
    # Basically same as https://github.com/NixOS/nixpkgs/pull/141299
    export ADW_DISABLE_PORTAL=1
    export XDG_DATA_DIRS=${glib.getSchemaDataDirPath gsettings-desktop-schemas}
  '';

  postInstall = ''
    # Pull in WebP and JXL support for gnome-backgrounds.
    # In postInstall to run before gappsWrapperArgsHook.
    export GDK_PIXBUF_MODULE_FILE="${
      gnome._gdkPixbufCacheBuilder_DO_NOT_USE {
        extraLoaders = [
          libjxl
          librsvg
          webp-pixbuf-loader
        ];
      }
    }"
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix XDG_DATA_DIRS : "${sound-theme-freedesktop}/share"
      # Thumbnailers (for setting user profile pictures)
      --prefix XDG_DATA_DIRS : "${gdk-pixbuf}/share"
      --prefix XDG_DATA_DIRS : "${librsvg}/share"
      # WM keyboard shortcuts
      --prefix XDG_DATA_DIRS : "${mutter}/share"
    )
    for i in $out/share/applications/*; do
      substituteInPlace $i --replace "Exec=gnome-control-center" "Exec=$out/bin/gnome-control-center"
    done
  '';

  separateDebugInfo = true;

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "gnome-control-center";
    };
  };

  meta = with lib; {
    description = "Utilities to configure the GNOME desktop";
    mainProgram = "gnome-control-center";
    license = licenses.gpl2Plus;
    maintainers = teams.gnome.members;
    platforms = platforms.linux;
  };
})
