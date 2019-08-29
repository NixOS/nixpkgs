{ stdenv, python3Packages }:

with python3Packages;

buildPythonApplication rec {
  pname = "img2pdf";
  version = "0.3.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1ksn33j9d9df04n4jx7dli70d700rafbm37gjaz6lwsswrzc2xwx";
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
