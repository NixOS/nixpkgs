{ stdenv, python3Packages }:

with python3Packages;

buildPythonApplication rec {
  pname = "img2pdf";
  version = "0.3.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0jgfk191vvxn2r6bbdknvw5v510mx9g0xrgnmcghaxkv65zjnj0b";
  };

  doCheck = false; # needs pdfrw

  propagatedBuildInputs = [
    pillow
  ];

  meta = with stdenv.lib; {
    description = "Convert images to PDF via direct JPEG inclusion";
    homepage = "https://gitlab.mister-muffin.de/josch/img2pdf";
    license = licenses.lgpl2;
    platforms = platforms.unix;
    maintainers = [ maintainers.veprbl ];
  };
}
