{
  lib,
  autoreconfHook,
  fetchFromSavannah,
  guile,
  pkg-config,
  stdenv,
  texinfo,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "guile-json";
  version = "4.7.3";

  src = fetchFromSavannah {
    repo = "guile-json";
    rev = finalAttrs.version;
    hash = "sha256-BrhEJQsPn2sP4AF06WI9skRoWGKGA+xdKdShLTuqcCo=";
  };

  nativeBuildInputs = [
    autoreconfHook
    guile
    pkg-config
    texinfo
  ];

  buildInputs = [ guile ];

  makeFlags = [ "GUILE_AUTO_COMPILE=0" ];

  doCheck = true;

  strictDeps = true;

  meta = {
    description = "JSON Bindings for GNU Guile";
    homepage = "https://savannah.nongnu.org/projects/guile-json";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ ethancedwards8 ];
    platforms = lib.platforms.all;
  };
})
