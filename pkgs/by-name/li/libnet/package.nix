{
  lib,
  stdenv,
  fetchFromGitHub,
  autoconf,
  automake,
  libtool,
  bash,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libnet";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "sam-github";
    repo = "libnet";
    rev = "v${finalAttrs.version}";
    hash = "sha256-P3LaDMMNPyEnA8nO1Bm7H0mW/hVBr0cFdg+p2JmWcGI=";
  };

  strictDeps = true;
  enableParallelBuilding = true;

  outputs = [
    "out"
    "dev"
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

  preFixup = ''
    moveToOutput bin/libnet-config "$dev"
  '';

  meta = {
    homepage = "https://github.com/sam-github/libnet";
    description = "Portable framework for low-level network packet construction";
    mainProgram = "libnet-config";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
  };
})
