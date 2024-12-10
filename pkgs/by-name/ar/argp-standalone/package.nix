{ lib, stdenv, fetchFromGitHub, meson, ninja }:

stdenv.mkDerivation rec {
  pname = "argp-standalone";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "argp-standalone";
    repo = "argp-standalone";
    rev = version;
    sha256 = "jWnoWVnUVDQlsC9ru7oB9PdtZuyCCNqGnMqF/f2m0ZY=";
  };

  nativeBuildInputs = [ meson ninja ];

  doCheck = true;

  meta = with lib; {
    homepage = "https://github.com/argp-standalone/argp-standalone";
    description = "Standalone version of arguments parsing functions from Glibc";
    platforms = platforms.unix;
    maintainers = with maintainers; [ amar1729 ];
    license = licenses.lgpl21Plus;
  };
}
