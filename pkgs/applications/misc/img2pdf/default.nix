{ stdenv, python3Packages }:

with python3Packages;

buildPythonApplication rec {
  pname = "img2pdf";
  version = "0.3.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "07wxgn5khmy94zqqv8l84q9b3yy84ddvwr2f7j4pjycrj2gg7si8";
  };

  doCheck = false; # needs pdfrw

  propagatedBuildInputs = [
    pillow
  ];

  meta = with stdenv.lib; {
    description = "Convert images to PDF via direct JPEG inclusion";
    homepage = https://gitlab.mister-muffin.de/josch/img2pdf;
    license = licenses.lgpl2;
    platforms = platforms.unix;
    maintainers = [ maintainers.veprbl ];
  };
}
