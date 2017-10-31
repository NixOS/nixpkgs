{ stdenv, fetchurl, pythonPackages, gettext, klick}:

pythonPackages.buildPythonApplication rec {
  name = "gtklick-${version}";
  namePrefix = "";
  version = "0.6.4";

  src = fetchurl {
    url = "http://das.nasophon.de/download/${name}.tar.gz";
    sha256 = "7799d884126ccc818678aed79d58057f8cf3528e9f1be771c3fa5b694d9d0137";
  };

  pythonPath = with pythonPackages; [
    pyliblo
    pyGtkGlade
  ];

  buildInputs = [ gettext ];

  propagatedBuildInputs = [ klick ];

  # wrapPythonPrograms breaks gtklick in the postFixup phase.
  # To fix it, apply wrapPythonPrograms and then clean up the wrapped file.
  postFixup = ''
    wrapPythonPrograms

    sed -i "/import sys; sys.argv\[0\] = 'gtklick'/d" $out/bin/.gtklick-wrapped
  '';

  meta = {
    homepage = http://das.nasophon.de/gtklick/;
    description = "Simple metronome with an easy-to-use GTK interface";
    license = stdenv.lib.licenses.gpl2Plus;
  };
}
