{
  lib,
  stdenv,
  fetchFromCodeberg,
  autoreconfHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gumbo";
  version = "0.14.0";

  src = fetchFromCodeberg {
    owner = "gumbo-parser";
    repo = "gumbo-parser";
    rev = finalAttrs.version;
    hash = "sha256-A/3ci5khNe2pKqd/WpNL25viw8YPFVYgKrQOICuCpD0=";
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
