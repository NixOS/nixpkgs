{
  lib,
  stdenv,
  fetchurl,
  guile,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gash";
  version = "0.3.2";

  src = fetchurl {
    url = "mirror://gnu/guix/mirror/gash-${finalAttrs.version}.tar.gz";
    hash = "sha256-yAwY530BGkSPIcQFmkdCfjTuG0zvcs9OvzkLXXGZ5OQ=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    guile # buildPlatform's guile is needed at build time
    pkg-config
  ];

  buildInputs = [
    guile
  ];

  meta = {
    description = "POSIX-compatible shell written in Guile Scheme";
    mainProgram = "gash";
    homepage = "https://savannah.nongnu.org/projects/gash/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ wegank ];
    platforms = lib.platforms.all;
  };
})
