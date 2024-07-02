{
  lib,
  python3Packages,
  fetchFromGitLab,
  blueprint-compiler,
  gobject-introspection,
  libadwaita,
  meson,
  ninja,
  pkg-config,
  wrapGAppsHook4,
}:
python3Packages.buildPythonApplication {
  pname = "showtime";
  version = "0-unstable-2024-06-07";

  src = fetchFromGitLab {
    owner = "GNOME/Incubator";
    repo = "showtime";
    rev = "9f3a96fe536a403e0d9f6557027b985a2eca18d6";
    hash = "sha256-r72GlbCXhiNN910TLbETt013wd8rumO8qkopd4W2Br4=";
    domain = "gitlab.gnome.org";
  };

  nativeBuildInputs = [
    blueprint-compiler
    gobject-introspection
    meson
    ninja
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [ libadwaita ];

  dependencies = with python3Packages; [ pygobject3 ];

  dontWrapGApps = true;
  makeWrapperArgs = [ ''''${gappsWrapperArgs[@]}'' ];

  meta = {
    description = "Watch without distraction";
    homepage = "https://gitlab.gnome.org/GNOME/Incubator/showtime";
    mainProgram = "showtime";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ getchoo ];
  };
}
