{ lib
, stdenv
, fetchurl
, guile
, pkg-config
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gash";
  version = "0.3.0";

  src = fetchurl {
    url = "mirror://savannah/gash/gash-${finalAttrs.version}.tar.gz";
    hash = "sha256-VGrsaRBo1nfFjd/BVpXbn4CGFuGfpzMi1Ppno8iXwqk=";
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
    homepage = "https://savannah.nongnu.org/projects/gash/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ wegank ];
    platforms = platforms.all;
  };
})
