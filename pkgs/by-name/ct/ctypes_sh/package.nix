{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  zlib,
  libffi,
  elfutils,
  libdwarf,
}:

stdenv.mkDerivation rec {
  pname = "ctypes.sh";
  version = "1.2";

  src = fetchFromGitHub {
    owner = "taviso";
    repo = pname;
    rev = "v${version}";
    sha256 = "1wafyfhwd7nf7xdici0djpwgykizaz7jlarn0r1b4spnpjx1zbx4";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];
  buildInputs = [
    zlib
    libffi
    elfutils
    libdwarf
  ];

  meta = with lib; {
    description = "Foreign function interface for bash";
    mainProgram = "ctypes.sh";
    homepage = "https://github.com/taviso/ctypes.sh";
    license = licenses.mit;
    maintainers = [ ];
    platforms = platforms.unix;
  };
}
