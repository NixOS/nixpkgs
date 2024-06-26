{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  hdf5,
  boost,
}:

stdenv.mkDerivation rec {
  pname = "minia";
  version = "3.2.1";

  src = fetchFromGitHub {
    owner = "GATB";
    repo = "minia";
    rev = "v${version}";
    sha256 = "0bmfrywixaaql898l0ixsfkhxjf2hb08ssnqzlzacfizxdp46siq";
    fetchSubmodules = true;
  };

  patches = [ ./no-bundle.patch ];

  env.NIX_CFLAGS_COMPILE = toString [ "-Wformat" ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    hdf5
    boost
  ];

  prePatch = ''
    rm -rf thirdparty/gatb-core/gatb-core/thirdparty/{hdf5,boost}
  '';

  meta = with lib; {
    description = "Short read genome assembler";
    mainProgram = "minia";
    homepage = "https://github.com/GATB/minia";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ jbedo ];
    platforms = [ "x86_64-linux" ];
  };
}
