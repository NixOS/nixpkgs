{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  meson,
  ninja,
  gettext,
  gnome,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gnome-video-effects";
  version = "0.6.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-video-effects/${lib.versions.majorMinor finalAttrs.version}/gnome-video-effects-${finalAttrs.version}.tar.xz";
    sha256 = "166utGs/WoMvsuDZC0K/jGFgICylKsmt0Xr84ZLjyKg=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gettext
  ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = finalAttrs.pname;
      versionPolicy = "none";
    };
  };

  meta = {
    description = "Collection of GStreamer effects to be used in different GNOME Modules";
    homepage = "https://gitlab.gnome.org/GNOME/gnome-video-effects";
    platforms = lib.platforms.unix;
    teams = [ lib.teams.gnome ];
    license = lib.licenses.gpl2;
  };
})
