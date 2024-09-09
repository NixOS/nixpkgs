{
  stdenv,
  lib,
  gettext,
  fetchurl,
  pkg-config,
  gtk3,
  glib,
  meson,
  ninja,
  upower,
  python3,
  desktop-file-utils,
  wrapGAppsHook3,
  gnome,
}:

stdenv.mkDerivation rec {
  pname = "gnome-power-manager";
  version = "43.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-power-manager/${lib.versions.major version}/gnome-power-manager-${version}.tar.xz";
    sha256 = "faq0i73bMOnfKrplDLYNBeZnyfiFrOagoeeVDgy90y8=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wrapGAppsHook3
    gettext

    # needed by meson_post_install.sh
    python3
    glib
    desktop-file-utils
  ];

  buildInputs = [
    gtk3
    glib
    upower
  ];

  passthru = {
    updateScript = gnome.updateScript { packageName = "gnome-power-manager"; };
  };

  meta = with lib; {
    homepage = "https://gitlab.gnome.org/GNOME/gnome-power-manager";
    description = "View battery and power statistics provided by UPower";
    mainProgram = "gnome-power-statistics";
    maintainers = teams.gnome.members;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
