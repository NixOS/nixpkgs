{ stdenv, fetchFromGitHub, gtk3, pythonPackages, intltool,
  pango, gsettings-desktop-schemas,
# Optional packages:
 enableOSM ? true, osm-gps-map
 }:

let
  inherit (pythonPackages) python buildPythonApplication;
in buildPythonApplication rec {
  version = "4.2.6";
  name = "gramps-${version}";

  buildInputs = [ intltool gtk3 ] 
    # Map support
    ++ stdenv.lib.optional enableOSM osm-gps-map
  ;

  # Currently broken
  doCheck = false;

  src = fetchFromGitHub {
    owner = "gramps-project";
    repo = "gramps";
    rev = "v${version}";
    sha256 = "0k0bx6msc2kvkg0nwa9v2mp3qy7lmnxjd97n6a1zdzlq8yzw29f1";
  };

  pythonPath = with pythonPackages; [ bsddb3 PyICU pygobject3 pycairo ] ++ [ pango ];

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

  # gobjectIntrospection package, wrap accordingly
  preFixup = ''
    wrapProgram $out/bin/gramps \
      --prefix GI_TYPELIB_PATH : "$GI_TYPELIB_PATH" \
      --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH:$out/share"
  '';

  meta = with stdenv.lib; {
    description = "Genealogy software";
    homepage = http://gramps-project.org;
    license = licenses.gpl2;
  };
}
