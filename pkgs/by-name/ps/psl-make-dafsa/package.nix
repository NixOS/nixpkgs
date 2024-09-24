{
  lib,
  stdenv,
  libpsl,
  lzip,
  python3,
}:

stdenv.mkDerivation rec {
  pname = "psl-make-dafsa";
  version = "0.21.5";

  inherit (libpsl) src;

  buildInputs = [ python3 ];

  dontBuild = true;
  dontConfigure = true;
  installPhase = ''
    install -m755 -D src/psl-make-dafsa $out/bin/psl-make-dafsa
    install -m644 -D src/psl-make-dafsa.1 $out/share/man/man1/psl-make-dafsa.1
  '';

  nativeBuildInputs = [ lzip ];

  meta = with lib; {
    description = "Generate a compact and optimized DAFSA from a Public Suffix List";
    homepage = "https://rockdaboot.github.io/libpsl/";
    changelog = "https://raw.githubusercontent.com/rockdaboot/libpsl/libpsl-${version}/NEWS";
    license = licenses.mit;
    maintainers = [ maintainers.c0bw3b ];
    mainProgram = "psl";
    platforms = platforms.unix ++ platforms.windows;
  };
}
