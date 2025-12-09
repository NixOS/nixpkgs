{
  stdenv,
  lib,
  fetchFromGitHub,
  gtk3,
  python3Packages,
  glibcLocales,
  intltool,
  gexiv2,
  pango,
  gobject-introspection,
  wrapGAppsHook3,
  gettext,
  desktopToDarwinBundle,
  # Optional packages:
  enableOSM ? true,
  osm-gps-map,
  glib-networking,
  enableGraphviz ? true,
  graphviz,
  enableGhostscript ? true,
  ghostscript,
}:

python3Packages.buildPythonApplication rec {
  version = "6.0.6";
  pname = "gramps";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "gramps-project";
    repo = "gramps";
    tag = "v${version}";
    hash = "sha256-+sWO+c7haKXH42JVT6Zpz70cHdGC/TPgBUMSD+0+/JI=";
  };

  patches = [
    # textdomain doesn't exist as a property on locale when running on Darwin
    ./check-locale-hasattr-textdomain.patch
    # disables the startup warning about bad GTK installation
    ./disable-gtk-warning-dialog.patch
  ];

  build-system = [
    python3Packages.setuptools
  ];

  dependencies = with python3Packages; [
    berkeleydb
    orjson
    pyicu
    pygobject3
    pycairo
  ];

  nativeBuildInputs = [
    wrapGAppsHook3
    intltool
    gettext
    gobject-introspection
  ];

  nativeCheckInputs = [
    glibcLocales
    python3Packages.unittestCheckHook
    python3Packages.jsonschema
    python3Packages.mock
    python3Packages.lxml
  ]
  # TODO: use JHBuild to build the Gramps' bundle
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    desktopToDarwinBundle
  ];

  buildInputs = [
    gtk3
    pango
    gexiv2
  ]
  # Map support
  ++ lib.optionals enableOSM [
    osm-gps-map
    glib-networking
  ]
  # Graphviz support
  ++ lib.optional enableGraphviz graphviz
  # Ghostscript support
  ++ lib.optional enableGhostscript ghostscript;

  preCheck = ''
    export HOME=$(mktemp -d)
    mkdir .git # Make gramps think that it's not in an installed state
  '';

  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=(
      "''${gappsWrapperArgs[@]}"
    )
  '';

  # https://github.com/NixOS/nixpkgs/issues/149812
  # https://nixos.org/manual/nixpkgs/stable/#ssec-gnome-hooks-gobject-introspection
  strictDeps = false;

  meta = with lib; {
    description = "Genealogy software";
    mainProgram = "gramps";
    homepage = "https://gramps-project.org";
    maintainers = with maintainers; [
      jk
      pinpox
      tomasajt
    ];
    changelog = "https://github.com/gramps-project/gramps/blob/${src.tag}/ChangeLog";
    longDescription = ''
      Every person has their own story but they are also part of a collective
      family history. Gramps gives you the ability to record the many details of
      an individual's life as well as the complex relationships between various
      people, places and events. All of your research is kept organized,
      searchable and as precise as you need it to be.
    '';
    license = licenses.gpl2Plus;
  };
}
