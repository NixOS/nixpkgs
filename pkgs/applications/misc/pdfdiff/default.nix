{ stdenv, pythonPackages, fetchurl, xpdf }:
let
  py = pythonPackages;
in
py.buildPythonApplication rec {
  name = "pdfdiff-${version}";
  version = "0.92";

  src = fetchurl {
    url = "http://www.cs.ox.ac.uk/people/cas.cremers/downloads/software/pdfdiff.py";
    sha256 = "0zxwjjbklz87wkbhkmsvhc7xmv5php7m2a9vm6ydhmhlxsybf836";
  };

  buildInputs = [  pythonPackages.wrapPython ];

  doCheck = false;

  phases = [ "unpackPhase" "patchPhase" "installPhase" ];

  unpackPhase = "cp $src pdfdiff.py";

  postPatch = ''
    sed -i -r 's|pdftotextProgram = "pdftotext"|pdftotextProgram = "${xpdf}/bin/pdftotext"|' pdfdiff.py
    sed -i -r 's|progName = "pdfdiff.py"|progName = "pdfdiff"|' pdfdiff.py
    '';

  installPhase = ''
    mkdir -p $out/bin
    cp pdfdiff.py $out/bin/pdfdiff
    chmod +x $out/bin/pdfdiff

    substituteInPlace $out/bin/pdfdiff --replace "#!/usr/bin/python" "#!${pythonPackages.python.interpreter}"
    '';

  meta = with stdenv.lib; {
    homepage = http://www.cs.ox.ac.uk/people/cas.cremers/misc/pdfdiff.html;
    description = "Tool to view the difference between two PDF or PS files";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
