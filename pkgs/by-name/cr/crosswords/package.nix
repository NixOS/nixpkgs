{
  lib,
  stdenv,
  fetchFromGitLab,
  meson,
  ninja,
  pkg-config,
  wrapGAppsHook4,
  desktop-file-utils,
  libadwaita,
  isocodes,
  json-glib,
  libipuz,
}:

stdenv.mkDerivation rec {
  pname = "crosswords";
  version = "0.3.15";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "jrb";
    repo = "crosswords";
    rev = version;
    hash = "sha256-KcHcTjPoQNA5TBXnKgudjBTV/0JbeVMJ09XVAL7SizI=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wrapGAppsHook4
    desktop-file-utils
  ];

  buildInputs = [
    libadwaita
    isocodes
    json-glib
    libipuz
  ];

  passthru.updateScript = ./update.bash;

  meta = {
    description = "Crossword player and editor for GNOME";
    homepage = "https://gitlab.gnome.org/jrb/crosswords";
    changelog = "https://gitlab.gnome.org/jrb/crosswords/-/blob/${version}/NEWS.md?ref_type=tags";
    license = lib.licenses.gpl3Plus;
    mainProgram = "crosswords";
    maintainers = with lib.maintainers; [ aleksana ];
    platforms = lib.platforms.unix;
  };
}
