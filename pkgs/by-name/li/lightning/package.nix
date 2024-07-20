{ lib
, fetchurl
, libopcodes
, libiberty
, stdenv
, libbfd
, zlib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lightning";
  version = "2.2.3";

  src = fetchurl {
    url = "mirror://gnu/lightning/lightning-${finalAttrs.version}.tar.gz";
    hash = "sha256-wEXHozoAr/v+sRBm+lAsA5kuR0piupWXeq0G28FMaCk=";
  };

  outputs = [ "out" "dev" "info" ];

  buildInputs = [
    libopcodes
    libbfd
    libiberty
    zlib
  ];

  strictDeps = true;

  configureFlags = [
    (lib.enableFeature true "disassembler")
  ];

  doCheck = true;

  meta = {
    homepage = "https://www.gnu.org/software/lightning/";
    changelog = "https://git.savannah.gnu.org/cgit/lightning.git/tree/ChangeLog?h=lightning-${finalAttrs.version}";
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
