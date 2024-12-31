{ lib
, stdenv
, fetchFromGitLab
, meson
, ninja
, pkg-config
, gjs
, gobject-introspection
, blueprint-compiler
, wrapGAppsHook4
, desktop-file-utils
, libadwaita
, libgda6
, gsound
, gst_all_1
, libportal-gtk4
}:

stdenv.mkDerivation {
  pname = "pomodoro-gtk";
  version = "1.4.1";

  src = fetchFromGitLab {
    owner = "idevecore";
    repo = "pomodoro";
    rev = "44b724557539084991f3eb55b9593053a2c73eba"; # author didn't make a tag
    fetchSubmodules = true;
    hash = "sha256-krVRVMrrzuqPY/3P9dCz7rVCCW7/j5cpT95XniGpBEs=";
  };

  postPatch = ''
    patchShebangs --build troll/gjspack/bin/gjspack
  '';

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gjs # runtime for gjspack
    gobject-introspection
    blueprint-compiler
    wrapGAppsHook4
    desktop-file-utils
  ];

  buildInputs = [
    gjs
    libadwaita
    libgda6
    gsound
    gst_all_1.gst-plugins-base
    libportal-gtk4
  ];

  meta = {
    description = "Simple and intuitive timer application (also named Planytimer)";
    homepage = "https://gitlab.com/idevecore/pomodoro";
    license = lib.licenses.gpl3Plus;
    mainProgram = "pomodoro";
    maintainers = with lib.maintainers; [ aleksana ];
    platforms = lib.platforms.unix;
  };
}
