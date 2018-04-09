{ stdenv, fetchFromGitHub, gtk3, pythonPackages, intltool, gnome3,
  pango, gsettings-desktop-schemas, gobjectIntrospection, wrapGAppsHook,
# Optional packages:
 enableOSM ? true, osm-gps-map
 }:

let
  inherit (pythonPackages) python buildPythonApplication;
in buildPythonApplication rec {
  version = "4.2.8";
  name = "gramps-${version}";

  nativeBuildInputs = [ wrapGAppsHook ];
  buildInputs = [ intltool gtk3 gobjectIntrospection pango gnome3.gexiv2 ] 
    # Map support
    ++ stdenv.lib.optional enableOSM osm-gps-map
  ;

  src = fetchFromGitHub {
    owner = "gramps-project";
    repo = "gramps";
    rev = "v${version}";
    sha256 = "17y6rjvvcz7lwjck4f5nmhnn07i9k5vzk5dp1jk7j3ldxjagscsd";
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
    homepage = http://gramps-project.org;
    license = licenses.gpl2;
  };
}
