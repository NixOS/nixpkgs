{
  lib,
  stdenv,
  desktop-file-utils,
  fetchFromGitLab,
  isocodes,
  json-glib,
  libadwaita,
  libipuz,
  meson,
  ninja,
  nix-update-script,
  pkg-config,
  shared-mime-info,
  wrapGAppsHook4,
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
    desktop-file-utils
    meson
    ninja
    pkg-config
    shared-mime-info
    wrapGAppsHook4
  ];

  buildInputs = [
    isocodes
    json-glib
    libadwaita
    libipuz
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Crossword player and editor for GNOME";
    homepage = "https://gitlab.gnome.org/jrb/crosswords";
    changelog = "https://gitlab.gnome.org/jrb/crosswords/-/blob/${version}/NEWS.md?ref_type=tags";
    license = lib.licenses.gpl3Plus;
    mainProgram = "crosswords";
    maintainers = with lib.maintainers; [
      aleksana
      l0b0
    ];
    platforms = lib.platforms.unix;
  };
}
