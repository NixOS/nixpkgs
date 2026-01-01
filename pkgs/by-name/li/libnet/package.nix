{
  lib,
  stdenv,
  fetchFromGitHub,
  autoconf,
  automake,
  libtool,
<<<<<<< HEAD
  bash,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  strictDeps = true;
  enableParallelBuilding = true;

  outputs = [
    "out"
    "dev"
  ];

=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  nativeBuildInputs = [
    autoconf
    automake
    libtool
  ];

<<<<<<< HEAD
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
=======
  preConfigure = "./autogen.sh";

  meta = with lib; {
    homepage = "https://github.com/sam-github/libnet";
    description = "Portable framework for low-level network packet construction";
    mainProgram = "libnet-config";
    license = licenses.bsd3;
    platforms = platforms.unix;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
