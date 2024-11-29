{
  mkDerivation,
  libgeom,
  libufs,
  openssl,
}:
let
  libs = mkDerivation {
    name = "geom-class-libs";
    path = "lib/geom";
    extraPaths = [
      "lib/Makefile.inc"
      "sbin/geom"
      "sys/geom"

      # geli isn't okay with just libcrypt, it wants files in here
      "sys/crypto/sha2"
      "sys/opencrypto"
    ];

    # libgeom needs sbuf and bsdxml but linker doesn't know that
    buildInputs = [
      libgeom
      libufs
      openssl
    ];

    # tools want geom headers but don't seem to declare it
    preBuild = ''
      export NIX_CFLAGS_COMPILE="-I$BSDSRCDIR/sys $NIX_CFLAGS_COMPILE";
    '';
  };
in
mkDerivation {
  path = "sbin/geom";
  extraPaths = [
    "lib/Makefile.inc"
    "lib/geom"
  ];

  GEOM_CLASS_DIR = "${libs}/lib";

  buildInputs = [ libgeom ];
}
