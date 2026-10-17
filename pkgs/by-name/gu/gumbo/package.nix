{
  lib,
  stdenv,
  fetchFromCodeberg,
  autoreconfHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gumbo";
  version = "0.14.1";

  src = fetchFromCodeberg {
    owner = "gumbo-parser";
    repo = "gumbo-parser";
    rev = finalAttrs.version;
    hash = "sha256-ir63pDxENWAz1PNPBfjev2Sg46yaRNkE6cBjeuIudfY=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  enableParallelBuilding = true;

  meta = {
    description = "C99 HTML parsing algorithm";
    homepage = "https://codeberg.org/gumbo-parser/gumbo-parser";
    maintainers = [ lib.maintainers.nico202 ];
    platforms = with lib.platforms; linux ++ darwin;
    license = lib.licenses.asl20;
  };
})
