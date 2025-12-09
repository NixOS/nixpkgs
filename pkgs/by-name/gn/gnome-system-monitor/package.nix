{
  lib,
  stdenv,
  gettext,
  fetchurl,
  pkg-config,
  gtkmm4,
  bash,
  catch2,
  gtk4,
  libadwaita,
  glib,
  wrapGAppsHook4,
  meson,
  ninja,
  gsettings-desktop-schemas,
  itstool,
  gnome,
  adwaita-icon-theme,
  librsvg,
  gdk-pixbuf,
  libgtop,
  systemd,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gnome-system-monitor";
  version = "49.1";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-system-monitor/${lib.versions.major finalAttrs.version}/gnome-system-monitor-${finalAttrs.version}.tar.xz";
    hash = "sha256-kVtqMhraEuunv1eMIMn+XkH1XVMoR8vRJLvdquwR1w8=";
  };

  patches = [
    # Fix pkexec detection on NixOS.
    ./fix-paths.patch
  ];

  nativeBuildInputs = [
    pkg-config
    gettext
    itstool
    wrapGAppsHook4
    meson
    ninja
    glib
  ];

  buildInputs = [
    bash
    catch2
    gtk4
    libadwaita
    glib
    gtkmm4
    libgtop
    gdk-pixbuf
    adwaita-icon-theme
    librsvg
    gsettings-desktop-schemas
    systemd
  ];

  mesonFlags = [
    # <artificial>:(.text.startup+0x56): undefined reference to `GsmApplication::get()'
    "-Db_lto=false"
  ];

  doCheck = true;

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "gnome-system-monitor";
    };
  };

  meta = with lib; {
    homepage = "https://apps.gnome.org/SystemMonitor/";
    description = "System Monitor shows you what programs are running and how much processor time, memory, and disk space are being used";
    mainProgram = "gnome-system-monitor";
    teams = [ teams.gnome ];
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
})
