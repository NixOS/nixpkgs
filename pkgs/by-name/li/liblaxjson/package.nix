{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  version = "1.0.5";
  pname = "liblaxjson";

  src = fetchFromGitHub {
    owner = "andrewrk";
    repo = "liblaxjson";
    rev = version;
    sha256 = "01iqbpbhnqfifhv82m6hi8190w5sdim4qyrkss7z1zyv3gpchc5s";
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "Library for parsing JSON config files";
    homepage = "https://github.com/andrewrk/liblaxjson";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = [ maintainers.andrewrk ];
  };
}
