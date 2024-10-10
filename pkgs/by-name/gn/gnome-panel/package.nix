{
  stdenv,
  lib,
  fetchurl,
  autoreconfHook,
  dconf,
  evolution-data-server,
  gdm,
  geocode-glib_2,
  gettext,
  glib,
  gnome-desktop,
  gnome-menus,
  gnome,
  gtk3,
  itstool,
  libgweather,
  libwnck,
  libxml2,
  pkg-config,
  polkit,
  systemd,
  wrapGAppsHook3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gnome-panel";
  version = "3.54.0";

  outputs = [
    "out"
    "dev"
    "man"
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-panel/${lib.versions.majorMinor finalAttrs.version}/gnome-panel-${finalAttrs.version}.tar.xz";
    hash = "sha256-lLnNUcpQ/zKiic1QWRNuexYMHxJrXWZp4QbcqIUEXCg=";
  };

  patches = [
    # Load modules from path in `NIX_GNOME_PANEL_MODULESDIR` environment variable
    # instead of gnome-panel’s libdir so that the NixOS module can make gnome-panel
    # load modules from other packages as well.
    ./modulesdir-env-var.patch
  ];

  # make .desktop Exec absolute
  postPatch = ''
    patch -p0 <<END_PATCH
    +++ gnome-panel/gnome-panel.desktop.in
    @@ -7 +7 @@
    -Exec=gnome-panel
    +Exec=$out/bin/gnome-panel
    END_PATCH
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix XDG_DATA_DIRS : "${gnome-menus}/share"
      --prefix XDG_CONFIG_DIRS : "${gnome-menus}/etc/xdg"
    )
  '';

  nativeBuildInputs = [
    autoreconfHook
    gettext
    itstool
    libxml2
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    dconf
    evolution-data-server
    gdm
    geocode-glib_2
    glib
    gnome-desktop
    gnome-menus
    gtk3
    libgweather
    libwnck
    polkit
    systemd
  ];

  configureFlags = [
    "--enable-eds"
  ];

  enableParallelBuilding = true;

  doCheck = true;

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "gnome-panel";
      versionPolicy = "odd-unstable";
    };
  };

  meta = with lib; {
    description = "Component of Gnome Flashback that provides panels and default applets for the desktop";
    mainProgram = "gnome-panel";
    homepage = "https://gitlab.gnome.org/GNOME/gnome-panel";
    changelog = "https://gitlab.gnome.org/GNOME/gnome-panel/-/blob/${finalAttrs.version}/NEWS?ref_type=tags";
    license = licenses.gpl2Plus;
    maintainers = teams.gnome.members;
    platforms = platforms.linux;
  };
})
