{
  lib,
  stdenv,
  fetchFromGitHub,
  autoconf,
  automake,
  mandoc,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "owamp";
  version = "4.4.6";

  src = fetchFromGitHub {
    owner = "perfsonar";
    repo = "owamp";
    tag = "v${finalAttrs.version}";
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

  meta = {
    homepage = "http://software.internet2.edu/owamp/";
    description = "Tool for performing one-way active measurements";
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.teto ];
    license = lib.licenses.asl20;
  };
})
