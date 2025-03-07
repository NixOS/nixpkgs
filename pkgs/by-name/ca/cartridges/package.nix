{
  lib,
  fetchFromGitHub,
  python3Packages,
  appstream,
  blueprint-compiler,
  desktop-file-utils,
  gobject-introspection,
  glib-networking,
  libadwaita,
  meson,
  ninja,
  pkg-config,
  wrapGAppsHook4,
}:
python3Packages.buildPythonApplication rec {
  pname = "cartridges";
  version = "2.8.5";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "kra-mo";
    repo = "cartridges";
    rev = "v${version}";
    hash = "sha256-7T+q3T8z8SCpAn3ayodZeETOsTwL+hhVWzY2JyBEoi4=";
  };

  # TODO: remove this when #286814 hits master
  mesonFlags = [ "-Dtiff_compression=jpeg" ];

  nativeBuildInputs = [
    appstream
    blueprint-compiler
    desktop-file-utils
    gobject-introspection
    meson
    ninja
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    glib-networking
    libadwaita
  ];

  dependencies = with python3Packages; [
    pillow
    pygobject3
    pyyaml
    requests
  ];

  dontWrapGApps = true;
  makeWrapperArgs = [ ''''${gappsWrapperArgs[@]}'' ];

  meta = {
    description = "GTK4 + Libadwaita game launcher";
    longDescription = ''
      A simple game launcher for all of your games.
      It has support for importing games from Steam, Lutris, Heroic
      and more with no login necessary.
      You can sort and hide games or download cover art from SteamGridDB.
    '';
    homepage = "https://apps.gnome.org/Cartridges/";
    changelog = "https://github.com/kra-mo/cartridges/releases/tag/${src.rev}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ getchoo ];
    mainProgram = "cartridges";
    platforms = lib.platforms.linux;
  };
}
