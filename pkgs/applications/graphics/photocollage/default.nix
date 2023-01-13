{ lib
, pkgs
, python
, wrapGAppsHook
}:

with python.pkgs;

buildPythonApplication rec {
  pname = "photocollage";
  version = "1.4.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-1YbPQJ63Ko0I8EPE3RPmV84q0D0S21vmZ0u7h1QFX5A=";
  };

  nativeBuildInputs = [
    pkgs.gobject-introspection
    wrapGAppsHook
  ];

  propagatedBuildInputs = [
    pkgs.gdk-pixbuf
    pkgs.gettext
    pkgs.gtk3

    pillow
    pycairo
    pygobject3
  ];

  patches = [
    ./import_gi.patch
  ];

  postPatch = ''
    substituteInPlace setup.py --replace "\"msgfmt\"" "\"${pkgs.gettext}/bin/msgfmt\""
  '';

  meta = with lib; {
    description = "Create photo collage posters";
    homepage = "https://github.com/adrienverge/PhotoCollage";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ pamplemousse ];
  };
}
