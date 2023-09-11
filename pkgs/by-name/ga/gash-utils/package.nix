{ lib
, stdenv
, fetchurl
, guile
, makeWrapper
, pkg-config
, gash
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gash-utils";
  version = "0.2.0";

  src = fetchurl {
    url = "mirror://savannah/gash/gash-utils-${finalAttrs.version}.tar.gz";
    hash = "sha256-5qrlpvQP34xfhzD2bD+MMEe94A+M2XWV9arSRElZ1KM=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    guile # buildPlatform's guile is needed at build time
    makeWrapper
    pkg-config
  ];

  buildInputs = [
    gash
    guile
  ];

  postInstall = ''
    for f in $out/bin/*; do
      wrapProgram $f \
        --prefix GUILE_LOAD_PATH : "${gash}/${guile.siteDir}"
    done
  '';

  meta = with lib; {
    description = "Core POSIX utilities written in Guile Scheme";
    homepage = "https://savannah.nongnu.org/projects/gash/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ wegank ];
    platforms = platforms.all;
  };
})
