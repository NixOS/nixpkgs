{ lib, fetchFromGitHub, gtk3, pythonPackages, intltool, gexiv2,
  pango, gobject-introspection, wrapGAppsHook, gettext,
# Optional packages:
 enableOSM ? true, osm-gps-map,
 enableGraphviz ? true, graphviz,
 enableGhostscript ? true, ghostscript
 }:

let
  inherit (pythonPackages) python buildPythonApplication;
in buildPythonApplication rec {
  version = "5.1.3";
  pname = "gramps";

  nativeBuildInputs = [ wrapGAppsHook intltool gettext ];
  buildInputs = [ gtk3 gobject-introspection pango gexiv2 ]
    # Map support
    ++ lib.optional enableOSM osm-gps-map
    # Graphviz support
    ++ lib.optional enableGraphviz graphviz
    # Ghostscript support
    ++ lib.optional enableGhostscript ghostscript
  ;

  src = fetchFromGitHub {
    owner = "gramps-project";
    repo = "gramps";
    rev = "v${version}";
    sha256 = "109dwkswz2h2328xkqk2zj736d117s9pp7rz5cc1qg2vxn1lpm93";
  };

  pythonPath = with pythonPackages; [ bsddb3 PyICU pygobject3 pycairo ];

  # Same installPhase as in buildPythonApplication but without --old-and-unmanageble
  # install flag.
  installPhase = ''
    runHook preInstall

    mkdir -p "$out/lib/${python.libPrefix}/site-packages"

    export PYTHONPATH="$out/lib/${python.libPrefix}/site-packages:$PYTHONPATH"

    ${python}/bin/${python.executable} setup.py install \
      --install-lib=$out/lib/${python.libPrefix}/site-packages \
      --prefix="$out"

    eapth="$out/lib/${python.libPrefix}"/site-packages/easy-install.pth
    if [ -e "$eapth" ]; then
        # move colliding easy_install.pth to specifically named one
        mv "$eapth" $(dirname "$eapth")/${pname}-${version}.pth
    fi

    rm -f "$out/lib/${python.libPrefix}"/site-packages/site.py*

    runHook postInstall
  '';

  meta = with lib; {
    description = "Genealogy software";
    homepage = "https://gramps-project.org";
    license = licenses.gpl2;
  };
}
