{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
  tzdata,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "0.4.11";
  pname = "dateutils";

  src = fetchurl {
    url = "https://bitbucket.org/hroptatyr/dateutils/downloads/dateutils-${finalAttrs.version}.tar.xz";
    sha256 = "sha256-uP6gsJcUu63yArmzQ0zOa1nCgueGkmjQwIuFiA/btEY=";
  };

  # https://github.com/hroptatyr/dateutils/issues/148
  postPatch = "rm test/dzone.008.ctst";

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ tzdata ]; # needed for datezone
  enableParallelBuilding = true;

  doCheck = true;

  meta = {
    description = "Bunch of tools that revolve around fiddling with dates and times in the command line";
    homepage = "http://www.fresse.org/dateutils/";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.paperdigits ];
  };
})
