{
  lib,
  stdenvNoCC,
  fetchurl,
  meson,
  ninja,
  gettext,
  gitUpdater,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "mate-backgrounds";
  version = "1.28.0";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${lib.versions.majorMinor finalAttrs.version}/mate-backgrounds-${finalAttrs.version}.tar.xz";
    sha256 = "UNGv0CSGvQesIqWmtu+jAxFI8NSKguSI2QmtVwA6aUM=";
  };

  nativeBuildInputs = [
    gettext
    meson
    ninja
  ];

  passthru.updateScript = gitUpdater {
    url = "https://git.mate-desktop.org/mate-backgrounds";
    odd-unstable = true;
    rev-prefix = "v";
  };

  meta = {
    description = "Background images and data for MATE";
    homepage = "https://mate-desktop.org";
    license = with lib.licenses; [
      gpl2Plus
      cc-by-sa-40
    ];
    platforms = lib.platforms.unix;
    teams = [ lib.teams.mate ];
  };
})
