{ lib, python2Packages, fetchurl, xpdf }:
let
  py = python2Packages;
in
py.buildPythonApplication rec {
  name = "pdfdiff-${version}";
  version = "0.92";

  src = fetchurl {
    url = "https://www.cs.ox.ac.uk/people/cas.cremers/downloads/software/pdfdiff.py";
    sha256 = "0zxwjjbklz87wkbhkmsvhc7xmv5php7m2a9vm6ydhmhlxsybf836";
  };

  buildInputs = [  python2Packages.wrapPython ];

  dontConfigure = true;
  dontBuild = true;
  doCheck = false;

  unpackPhase = "cp $src pdfdiff.py";

  postPatch = ''
    sed -i -r 's|pdftotextProgram = "pdftotext"|pdftotextProgram = "${xpdf}/bin/pdftotext"|' pdfdiff.py
    sed -i -r 's|progName = "pdfdiff.py"|progName = "pdfdiff"|' pdfdiff.py
    '';

  installPhase = ''
    mkdir -p $out/bin
    cp pdfdiff.py $out/bin/pdfdiff
    chmod +x $out/bin/pdfdiff

    substituteInPlace $out/bin/pdfdiff --replace "#!/usr/bin/python" "#!${python2Packages.python.interpreter}"
    '';

  meta = with lib; {
    homepage = "http://www.cs.ox.ac.uk/people/cas.cremers/misc/pdfdiff.html";
    description = "Tool to view the difference between two PDF or PS files";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
