{
  lib,
  stdenvNoCC,
  fetchurl,
  meson,
  ninja,
  gnome,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "adwaita-fonts";
  version = "50.0";

  src = fetchurl {
    url = "mirror://gnome/sources/adwaita-fonts/${lib.versions.major finalAttrs.version}/adwaita-fonts-${finalAttrs.version}.tar.xz";
    hash = "sha256-TJJ/v+7BxQOAG6UQwslOAFTILFIs97oNO+XU1B/PXIY=";
  };

  nativeBuildInputs = [
    meson
    ninja
  ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "adwaita-fonts";
    };
  };

  meta = {
    description = "Adwaita Sans, a variation of Inter, and Adwaita Mono, Iosevka customized to match Inter";
    homepage = "https://gitlab.gnome.org/GNOME/adwaita-fonts";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.qxrein ];
    teams = [ lib.teams.gnome ];
  };
})
