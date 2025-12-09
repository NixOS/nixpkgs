{
  lib,
  stdenv,
  fetchFromGitHub,
  autoconf,
  automake,
  libtool,
  bash,
}:

stdenv.mkDerivation rec {
  pname = "libnet";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "sam-github";
    repo = "libnet";
    rev = "v${version}";
    hash = "sha256-P3LaDMMNPyEnA8nO1Bm7H0mW/hVBr0cFdg+p2JmWcGI=";
  };

  strictDeps = true;
  enableParallelBuilding = true;

  outputs = [
    "out"
    "lib"
  ];

  nativeBuildInputs = [
    autoconf
    automake
    libtool
  ];

  buildInputs = [
    bash
  ];

  preConfigure = "./autogen.sh";

  meta = with lib; {
    homepage = "https://github.com/sam-github/libnet";
    description = "Portable framework for low-level network packet construction";
    mainProgram = "libnet-config";
    license = licenses.bsd3;
    platforms = platforms.unix;
  };
}
