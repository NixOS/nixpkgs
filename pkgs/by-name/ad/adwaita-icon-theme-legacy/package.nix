{
  lib,
  stdenv,
  fetchurl,
  meson,
  ninja,
  gtk4,
  gnome,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "adwaita-icon-theme-legacy";
  version = "46.2";

  src = fetchurl {
    url = "mirror://gnome/sources/adwaita-icon-theme-legacy/${lib.versions.major finalAttrs.version}/adwaita-icon-theme-legacy-${finalAttrs.version}.tar.xz";
    hash = "sha256-VISA9YWJpUty0Ygzt1WxX/vVZ+MYcknXTi4fj5nyL7Q=";
  };

  nativeBuildInputs = [
    meson
    ninja
    gtk4 # for gtk4-update-icon-cache
  ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "adwaita-icon-theme-legacy";
    };
  };

  meta = with lib; {
    description = "Fullcolor icon theme providing fallback for legacy apps";
    homepage = "https://gitlab.gnome.org/GNOME/adwaita-icon-theme-legacy";
    license = licenses.cc-by-sa-30;
    maintainers = teams.gnome.members;
    platforms = platforms.all;
  };
})
