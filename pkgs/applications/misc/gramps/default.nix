{ lib
, fetchpatch
, fetchFromGitHub
, gtk3
, pythonPackages
, glibcLocales
, intltool
, gexiv2
, pango
, gobject-introspection
, wrapGAppsHook
, gettext
, # Optional packages:
  enableOSM ? true
, osm-gps-map
, glib-networking
, enableGraphviz ? true
, graphviz
, enableGhostscript ? true
, ghostscript
}:

let
  inherit (pythonPackages) python buildPythonApplication pythonOlder;
in
buildPythonApplication rec {
  version = "5.1.6";
  pname = "gramps";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "gramps-project";
    repo = "gramps";
    rev = "v${version}";
    hash = "sha256-BerkDXdFYfZ3rV5AeMo/uk53IN2U5z4GFs757Ar26v0=";
  };

  nativeBuildInputs = [
    wrapGAppsHook
    intltool
    gettext
    gobject-introspection
    pythonPackages.setuptools
  ];

  dontWrapGApps = true;

  nativeCheckInputs = [ glibcLocales ] ++ (with pythonPackages; [
    unittestCheckHook
    jsonschema
    mock
    lxml
  ]);

  buildInputs = [ gtk3 pango gexiv2 ]
    # Map support
    ++ lib.optionals enableOSM [ osm-gps-map glib-networking ]
    # Graphviz support
    ++ lib.optional enableGraphviz graphviz
    # Ghostscript support
    ++ lib.optional enableGhostscript ghostscript
  ;

  propagatedBuildInputs = with pythonPackages; [
    bsddb3
    pyicu
    pygobject3
    pycairo
  ];

  patches = [
    # fix for running tests with a temporary home - remove next release
    # https://gramps-project.org/bugs/view.php?id=12577
    (fetchpatch {
      url = "https://github.com/gramps-project/gramps/commit/1e95d8a6b5193d655d8caec1e6ab13628ad123db.patch";
      hash = "sha256-2riWB13Yl+tk9+Tuo0YDLoxY2Rc0xrJKfb+ZU7Puzxk=";
    })
  ];

  # fix bug with resolving the resource-path - remove next release
  postPatch = ''
    substituteInPlace gramps/gen/utils/resourcepath.py \
        --replace-fail "fp.readline()" "fp.readline().rstrip()"
  '';

  # tell gramps where the share directory is - remove next release
  postInstall = ''
    echo $out/share > $out/${python.sitePackages}/gramps/gen/utils/resource-path
  '';

  preCheck = ''
    export HOME=$TMPDIR
  '';

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
    homepage = "https://gramps-project.org";
    mainProgram = "gramps";
    maintainers = with maintainers; [ jk pinpox ];
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
