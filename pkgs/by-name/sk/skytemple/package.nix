{
  lib,
  fetchFromGitHub,
  gobject-introspection,
  gtk3,
  gtksourceview4,
  webkitgtk_4_0,
  wrapGAppsHook3,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "skytemple";
  version = "1.8.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "SkyTemple";
    repo = "skytemple";
    tag = version;
    hash = "sha256-jdiZLDQEfYESgpe7F5X/odkgXnvjhvfFArrpt4bpPbo=";
  };

  build-system = with python3Packages; [ setuptools ];

  buildInputs = [
    gtk3
    gtksourceview4
    # webkitgtk is used for rendering interactive statistics graph which
    # can be seen by opening a ROM, entering Pokemon section, selecting
    # any Pokemon, and clicking Stats and Moves tab.
    webkitgtk_4_0
  ];

  nativeBuildInputs = [
    gobject-introspection
    wrapGAppsHook3
  ];

  dependencies =
    with python3Packages;
    [
      cairosvg
      natsort
      ndspy
      packaging
      pycairo
      pygal
      psutil
      pypresence
      sentry-sdk
      setuptools
      skytemple-dtef
      skytemple-eventserver
      skytemple-files
      skytemple-icons
      skytemple-ssb-debugger
      tilequant
      wheel
    ]
    ++ skytemple-files.optional-dependencies.spritecollab;

  doCheck = false; # there are no tests

  postInstall = ''
    install -Dm444 org.skytemple.SkyTemple.desktop -t $out/share/applications
    install -Dm444 installer/skytemple.ico $out/share/icons/hicolor/256x256/apps/org.skytemple.SkyTemple.ico
  '';

  meta = with lib; {
    homepage = "https://github.com/SkyTemple/skytemple";
    description = "ROM hacking tool for Pokémon Mystery Dungeon Explorers of Sky";
    mainProgram = "skytemple";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ marius851000 ];
  };
}
