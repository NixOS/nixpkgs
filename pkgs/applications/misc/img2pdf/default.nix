{ stdenv, python3Packages }:

with python3Packages;

buildPythonApplication rec {
  pname = "img2pdf";
  version = "0.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "071s3gf28nb8ifxkix7dzjny6vib7791mnp0v3f4zagcjcic22a4";
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
