{
  stdenv,
  lib,
  fetchFromGitHub,
  chez,
}:

stdenv.mkDerivation rec {
  pname = "chez-srfi";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "fedeinthemix";
    repo = "chez-srfi";
    rev = "v${version}";
    sha256 = "sha256-yBhRNfoEt1LOn3/zd/yOWwfErN/qG/tQZnDRqEf8j/0=";
  };

  buildInputs = [ chez ];

  makeFlags = [
    "CHEZ=${lib.getExe chez}"
    "PREFIX=$(out)"
  ];

  doCheck = false;

  meta = with lib; {
    description = "This package provides a collection of SRFI libraries for Chez Scheme";
    homepage = "https://github.com/fedeinthemix/chez-srfi/";
    maintainers = [ maintainers.jitwit ];
    license = licenses.x11;
  };

}
