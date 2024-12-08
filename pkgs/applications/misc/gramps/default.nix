{ lib
, fetchFromGitHub
, gtk3
, pythonPackages
, glibcLocales
, intltool
, gexiv2
, pango
, gobject-introspection
, wrapGAppsHook3
, gettext
  # Optional packages:
, enableOSM ? true
, osm-gps-map
, glib-networking
, enableGraphviz ? true
, graphviz
, enableGhostscript ? true
, ghostscript
}:

let
  inherit (pythonPackages) buildPythonApplication pythonOlder;
in
buildPythonApplication rec {
  version = "5.2.3";
  pname = "gramps";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "gramps-project";
    repo = "gramps";
    rev = "refs/tags/v${version}";
    hash = "sha256-DfKKB+rgMGQ8HTqhCp11UTYLj3Fdd0B0v4a922GJ8L8=";
  };

  patches = [
    # textdomain doesn't exist as a property on locale when running on Darwin
    ./check-locale-hasattr-textdomain.patch
    # disables the startup warning about bad GTK installation
    ./disable-gtk-warning-dialog.patch
  ];

  nativeBuildInputs = [
    wrapGAppsHook3
    intltool
    gettext
    gobject-introspection
    pythonPackages.setuptools
  ];

  nativeCheckInputs = [
    glibcLocales
    pythonPackages.unittestCheckHook
    pythonPackages.jsonschema
    pythonPackages.mock
    pythonPackages.lxml
  ];

  buildInputs = [ gtk3 pango gexiv2 ]
    # Map support
    ++ lib.optionals enableOSM [ osm-gps-map glib-networking ]
    # Graphviz support
    ++ lib.optional enableGraphviz graphviz
    # Ghostscript support
    ++ lib.optional enableGhostscript ghostscript
  ;

  propagatedBuildInputs = with pythonPackages; [
    berkeleydb
    pyicu
    pygobject3
    pycairo
  ];


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
    maintainers = with maintainers; [ jk pinpox tomasajt ];
    changelog = "https://github.com/gramps-project/gramps/blob/${src.rev}/ChangeLog";
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
