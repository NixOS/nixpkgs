{ lib, fetchurl, python2Packages, gettext, klick}:

python2Packages.buildPythonApplication rec {
  pname = "gtklick";
  version = "0.6.4";

  src = fetchurl {
    url = "http://das.nasophon.de/download/${pname}-${version}.tar.gz";
    sha256 = "7799d884126ccc818678aed79d58057f8cf3528e9f1be771c3fa5b694d9d0137";
  };

  pythonPath = with python2Packages; [
    pyliblo
    pyGtkGlade
  ];

  nativeBuildInputs = [ gettext ];

  propagatedBuildInputs = [ klick ];

  # wrapPythonPrograms breaks gtklick in the postFixup phase.
  # To fix it, apply wrapPythonPrograms and then clean up the wrapped file.
  postFixup = ''
    wrapPythonPrograms

    sed -i "/import sys; sys.argv\[0\] = 'gtklick'/d" $out/bin/.gtklick-wrapped
  '';

  meta = {
    homepage = "http://das.nasophon.de/gtklick/";
    description = "Simple metronome with an easy-to-use GTK interface";
    license = lib.licenses.gpl2Plus;
  };
}
