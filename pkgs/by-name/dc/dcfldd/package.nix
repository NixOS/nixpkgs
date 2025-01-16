{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dcfldd";
  version = "1.3.4-1";

  src = fetchurl {
    url = "mirror://sourceforge/dcfldd/dcfldd-${finalAttrs.version}.tar.gz";
    sha256 = "1y6mwsvm75f5jzxsjjk0yhf8xnpmz6y8qvcxfandavx59lc3l57m";
  };

  enableParallelBuilding = true;

  # gcc14 is more strict
  env.NIX_CFLAGS_COMPILE = toString [
    "-Wno-error=implicit-function-declaration"
    "-Wno-error=implicit-int"
  ];

  meta = with lib; {
    description = "Enhanced version of GNU dd";

    homepage = "https://dcfldd.sourceforge.net/";

    license = licenses.gpl2Plus;

    platforms = platforms.all;
    maintainers = with maintainers; [ qknight ];
    mainProgram = "dcfldd";
  };
})
