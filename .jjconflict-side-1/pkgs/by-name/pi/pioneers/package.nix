{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  intltool,
  itstool,
  gtk3,
  libxml2,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pioneers";
  version = "15.6";

  src = fetchurl {
    url = "mirror://sourceforge/pio/pioneers-${finalAttrs.version}.tar.gz";
    sha256 = "07b3xdd81n8ybsb4fzc5lx0813y9crzp1hj69khncf4faj48sdcs";
  };

  nativeBuildInputs = [
    pkg-config
    intltool
    itstool
  ];

  buildInputs = [
    gtk3
    libxml2
  ];

  meta = {
    description = "Addicting game based on The Settlers of Catan";
    homepage = "https://pio.sourceforge.net/"; # https does not work
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
