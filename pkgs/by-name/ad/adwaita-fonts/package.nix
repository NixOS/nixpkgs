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
  version = "48.2";

  src = fetchurl {
    url = "mirror://gnome/sources/adwaita-fonts/${lib.versions.major finalAttrs.version}/adwaita-fonts-${finalAttrs.version}.tar.xz";
    hash = "sha256-FW9+kvL4LlJ/xzwwnbsjfApKXDqVvF7pSl77aUfFU+A=";
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
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.qxrein ];
    teams = [ lib.teams.gnome ];
  };
})
