{
  lib,
  stdenv,
  fetchurl,
  bison,
  lzo,
  db4,
}:

stdenv.mkDerivation rec {
  pname = "netboot";
  version = "0.10.2";

  src = fetchurl {
    url = "mirror://sourceforge/netboot/netboot-${version}.tar.gz";
    sha256 = "09w09bvwgb0xzn8hjz5rhi3aibysdadbg693ahn8rylnqfq4hwg0";
  };

  buildInputs = [
    bison
    lzo
    db4
  ];

  hardeningDisable = [ "format" ];

  # mgllex.l:398:53: error: passing argument 1 of 'copy_string' from incompatible pointer type []
  env.NIX_CFLAGS_COMPILE = "-Wno-error=incompatible-pointer-types";

  # Disable parallel build, errors:
  #  link: `parseopt.lo' is not a valid libtool object
  enableParallelBuilding = false;

  meta = with lib; {
    description = "Mini PXE server";
    maintainers = [ maintainers.raskin ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    license = lib.licenses.free;
  };
}
