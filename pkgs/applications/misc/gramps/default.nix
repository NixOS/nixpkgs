{ lib
, fetchFromGitHub
, gtk3
, buildPythonApplication
, intltool
, gexiv2
, pango
, gobject-introspection
, wrapGAppsHook
, gettext
, glibcLocales
, fetchpatch
  # optional packages:
, enableOSM ? true
, osm-gps-map
, glib-networking
, enableGraphviz ? true
, graphviz
, enableGhostscript ? true
, ghostscript
# python packages
, bsddb3
, PyICU
, pygobject3
, pycairo
# python test packages
, jsonschema
, lxml
, mock
}:

buildPythonApplication rec {
  pname = "gramps";
  version = "5.1.5";

  src = fetchFromGitHub {
    owner = "gramps-project";
    repo = "gramps";
    rev = "v${version}";
    sha256 = "sha256-j5wRnu9cDiLXDEiXtT6EfpsNjJRBgzKfl89OuIYAdm0=";
  };

  patches = [
    # fix for running tests with a temporary home - remove next release
    # https://gramps-project.org/bugs/view.php?id=12577
    (fetchpatch {
      url = "https://github.com/gramps-project/gramps/commit/1e95d8a6b5193d655d8caec1e6ab13628ad123db.patch";
      sha256 = "sha256-2riWB13Yl+tk9+Tuo0YDLoxY2Rc0xrJKfb+ZU7Puzxk=";
    })
  ];

  # https://github.com/NixOS/nixpkgs/issues/149812
  # https://nixos.org/manual/nixpkgs/stable/#ssec-gnome-hooks-gobject-introspection
  strictDeps = false;

  nativeBuildInputs = [ wrapGAppsHook intltool gettext ];
  buildInputs = [ gtk3 gobject-introspection pango gexiv2 ]
    # Map support
    ++ lib.optionals enableOSM [ osm-gps-map glib-networking ]
    # Graphviz support
    ++ lib.optional enableGraphviz graphviz
    # Ghostscript support
    ++ lib.optional enableGhostscript ghostscript
  ;
  propagatedBuildInputs = [ bsddb3 PyICU pygobject3 pycairo ];
  checkInputs = [ glibcLocales jsonschema lxml mock ];

  preCheck = ''
    # $HOME must be prefixed with $TMPDIR in order to skip a specific test
    # https://github.com/gramps-project/gramps/pull/1347
    export HOME="$(mktemp -d)"
  '';

  doCheck = true;

  meta = with lib; {
    homepage = "https://gramps-project.org";
    changelog = "https://github.com/gramps-project/gramps/blob/v${version}/ChangeLog";
    description = "Genealogy software";
    longDescription = ''
      Every person has their own story but they are also part of a collective
      family history. Gramps gives you the ability to record the many details of
      an individual's life as well as the complex relationships between various
      people, places and events. All of your research is kept organized,
      searchable and as precise as you need it to be.
    '';
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ jk ];
  };
}
