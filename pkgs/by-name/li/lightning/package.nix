{ lib
, fetchurl
, libopcodes
, stdenv
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lightning";
  version = "2.2.2";

  src = fetchurl {
    url = "mirror://gnu/lightning/lightning-${finalAttrs.version}.tar.gz";
    hash = "sha256-CsqCQt6tF9YhF7z8sHjmqeqFbMgXQoE8noOUvM5zs+I=";
  };

  outputs = [ "out" "dev" "info" ];

  nativeCheckInputs = [ libopcodes ];

  strictDeps = true;

  doCheck = true;

  meta = {
    homepage = "https://www.gnu.org/software/lightning/";
    description = "Run-time code generation library";
    longDescription = ''
      GNU lightning is a library that generates assembly language code at
      run-time; it is very fast, making it ideal for Just-In-Time compilers, and
      it abstracts over the target CPU, as it exposes to the clients a
      standardized RISC instruction set inspired by the MIPS and SPARC chips.
    '';
    maintainers = with lib.maintainers; [ AndersonTorres ];
    license = with lib.licenses; [ lgpl3Plus ];
    platforms = lib.platforms.unix;
    broken = stdenv.isDarwin; # failing tests
  };
})
