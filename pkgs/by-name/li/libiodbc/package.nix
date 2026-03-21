{
  config,
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  gtk2,
  useGTK ? config.libiodbc.gtk or false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libiodbc";
  version = "3.52.16";

  src = fetchurl {
    url = "mirror://sourceforge/iodbc/libiodbc-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-OJizLQeWE2D28s822zYDa3GaIw5HZGklioDzIkPoRfo=";
  };

  configureFlags = [
    "--disable-libodbc"
  ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = lib.optionals useGTK [ gtk2 ];

  # temporary workaround for compile error with GCC 15
  # https://github.com/openlink/iODBC/issues/113
  env.NIX_CFLAGS_COMPILE = "-std=gnu17";

  preBuild = ''
    export NIX_LDFLAGS_BEFORE="-rpath $out/lib"
  '';

  meta = {
    description = "iODBC driver manager";
    homepage = "https://www.iodbc.org";
    platforms = lib.platforms.unix;
    license = lib.licenses.bsd3;
  };
})
