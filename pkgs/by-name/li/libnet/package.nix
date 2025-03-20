{
  lib,
  stdenv,
  fetchFromGitHub,
  autoconf,
  automake,
  libtool,
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

  nativeBuildInputs = [
    autoconf
    automake
    libtool
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
