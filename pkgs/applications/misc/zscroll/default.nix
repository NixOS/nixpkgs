{ stdenv, lib, python3, python3Packages, fetchFromGitHub }:

let version = "1.0"; in

python3Packages.buildPythonApplication {
  name = "zscroll-${version}";
  # don't prefix with python version
  namePrefix = "";

  src = fetchFromGitHub {
    owner = "noctuid";
    repo = "zscroll";
    rev = "v${version}";
    sha256 = "0rf9m1czy19hzpcp8dq9c5zawk0nhwfzzjxlhk9r2n06lhb81ig5";
  };

  doCheck = false;

  propagatedBuildInputs = [ python3 ];

  meta = with stdenv.lib; {
    description = "A text scroller for use with panels and shells";
    homepage = https://github.com/noctuid/zscroll;
    license = licenses.bsd2;
    platforms = platforms.all;
  };
}
