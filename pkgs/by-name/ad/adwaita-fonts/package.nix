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
  version = "49.0";

  src = fetchurl {
    url = "mirror://gnome/sources/adwaita-fonts/${lib.versions.major finalAttrs.version}/adwaita-fonts-${finalAttrs.version}.tar.xz";
    hash = "sha256-MVfGIOtbcrJasVbRlKpOsiP5hw1Uf+g/298G0+e+yzc=";
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
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.qxrein ];
    teams = [ lib.teams.gnome ];
  };
})
