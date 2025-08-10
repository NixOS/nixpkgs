{
  lib,
  stdenv,
  fetchurl,
  guile,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gash";
  version = "0.3.1";

  src = fetchurl {
    url = "mirror://gnu/guix/mirror/gash-${finalAttrs.version}.tar.gz";
    hash = "sha256-RwPWo+Kg3ztZCC1Ku7vJXlr2Fp/OZGCTjC7O6eaPPBk=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    guile # buildPlatform's guile is needed at build time
    pkg-config
  ];

  buildInputs = [
    guile
  ];

  meta = with lib; {
    description = "POSIX-compatible shell written in Guile Scheme";
    mainProgram = "gash";
    homepage = "https://savannah.nongnu.org/projects/gash/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ wegank ];
    platforms = platforms.all;
  };
})
