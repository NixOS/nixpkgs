{ lib, python3, python3Packages, fetchFromGitHub }:

python3Packages.buildPythonApplication rec {
  pname = "zscroll";
  version = "2.0.1";

  # don't prefix with python version
  namePrefix = "";

  src = fetchFromGitHub {
    owner = "noctuid";
    repo = "zscroll";
    rev = "${version}";
    sha256 = "04s9qzcav2wxrrasc7irvjbzn4fvzsk1a7aw6ywd7klv61dnwjc0";
  };

  doCheck = false;

  propagatedBuildInputs = [ python3 ];

  meta = with lib; {
    description = "A text scroller for use with panels and shells";
    homepage = "https://github.com/noctuid/zscroll";
    license = licenses.bsd2;
    platforms = platforms.all;
  };
}
