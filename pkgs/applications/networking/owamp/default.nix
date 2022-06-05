{lib, stdenv, fetchFromGitHub
, autoconf, automake, mandoc }:

stdenv.mkDerivation rec {
  pname = "owamp";
  version = "3.5.6";
  nativeBuildInputs = [ autoconf automake ];
  buildInputs = [ mandoc ];
  src = fetchFromGitHub {
    owner = "perfsonar";
    repo = "owamp";
    rev = version;
    sha256="019rcshmrqk8pfp510j5jvazdcnz0igfkwv44mfxb5wirzj9p6s7";
    fetchSubmodules = true;
  };

  preConfigure = ''
    I2util/bootstrap.sh
    ./bootstrap
  '';

  meta = with lib; {
    homepage = "http://software.internet2.edu/owamp/";
    description = "A tool for performing one-way active measurements";
    platforms = platforms.linux;
    maintainers = [maintainers.teto];
    license = licenses.asl20;
  };
}
