{
  lib,
  stdenv,
  fetchFromGitHub,
  autoconf,
  automake,
  mandoc,
}:

stdenv.mkDerivation rec {
  pname = "owamp";
  version = "4.4.6";

  src = fetchFromGitHub {
    owner = "perfsonar";
    repo = "owamp";
    rev = "v${version}";
    sha256 = "5o85XSn84nOvNjIzlaZ2R6/TSHpKbWLXTO0FmqWsNMU=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    autoconf
    automake
  ];
  buildInputs = [ mandoc ];

  preConfigure = ''
    I2util/bootstrap.sh
    ./bootstrap
  '';

  meta = with lib; {
    homepage = "http://software.internet2.edu/owamp/";
    description = "Tool for performing one-way active measurements";
    platforms = platforms.linux;
    maintainers = [ maintainers.teto ];
    license = licenses.asl20;
  };
}
