{
  lib,
  fetchFromGitHub,
  gobject-introspection,
  gtk3,
  gtksourceview4,
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
    # SkyTemple uses webkitgtk 4.0 which is depend on libsoup2, an
    # unmaintained library. Since it is optional, do not use it.
    # It is only used to add interactive monster XP curver, that
    # can alternatively be opened in the web browser (and is also
    # rendered in-app as non-interactive image)
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
