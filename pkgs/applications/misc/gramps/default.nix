{ stdenv, fetchFromGitHub, gtk3, pythonPackages, intltool, gnome3,
  pango, gobject-introspection, wrapGAppsHook,
# Optional packages:
 enableOSM ? true, osm-gps-map,
 enableGraphviz ? true, graphviz,
 enableGhostscript ? true, ghostscript
 }:

let
  inherit (pythonPackages) python buildPythonApplication;
in buildPythonApplication rec {
  version = "5.0.1";
  name = "gramps-${version}";

  nativeBuildInputs = [ wrapGAppsHook ];
  buildInputs = [ intltool gtk3 gobject-introspection pango gnome3.gexiv2 ] 
    # Map support
    ++ stdenv.lib.optional enableOSM osm-gps-map
    # Graphviz support
    ++ stdenv.lib.optional enableGraphviz graphviz
    # Ghostscript support
    ++ stdenv.lib.optional enableGhostscript ghostscript
    
  ;

  src = fetchFromGitHub {
    owner = "gramps-project";
    repo = "gramps";
    rev = "v${version}";
    sha256 = "1jz1fbjj6byndvir7qxzhd2ryirrd5h2kwndxpp53xdc05z1i8g7";
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
        mv "$eapth" $(dirname "$eapth")/${name}.pth
    fi

    rm -f "$out/lib/${python.libPrefix}"/site-packages/site.py*

    runHook postInstall
  '';

  meta = with stdenv.lib; {
    description = "Genealogy software";
    homepage = https://gramps-project.org;
    license = licenses.gpl2;
    maintainers = with maintainers; [ joncojonathan ];
  };
}
