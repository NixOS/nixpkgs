{
  lib,
  fetchFromBitbucket,
  libxcrypt,
  ncurses,
  pkg-config,
  stdenv,
  unzip,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "qnial";
  version = "6.3_1";

  src = fetchFromBitbucket {
    owner = "museoa";
    repo = "qnial";
    rev = finalAttrs.version;
    hash = "sha256-QhjEq6YKO6OKy7+dlHeTWQvCvrF8zS7o8QfPD8WDXy0=";
  };

  nativeBuildInputs = [
    pkg-config
    unzip
  ];

  buildInputs = [
     ncurses
     libxcrypt
  ];

  strictDeps = true;

  preConfigure = ''
    cd build
  '';

  installPhase = ''
    cd ..
    mkdir -p $out/bin $out/lib
    cp build/nial $out/bin/
    cp -r niallib $out/lib/
  '';

  meta = {
    description = "Array language from Nial Systems";
    homepage = "https://bitbucket.com/museoa/qnial";
    license = lib.licenses.artistic1;
    mainProgram = "nial";
    maintainers = [ lib.maintainers.AndersonTorres ];
    platforms = lib.platforms.linux;
  };
})
