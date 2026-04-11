{
  lib,
  stdenv,
  fetchurl,
  expat,
  libpng,
  udunits,
  netcdf,
  libxt,
  libxaw,
  libx11,
  libsm,
  libice,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ncview";
  version = "2.1.9";

  src = fetchurl {
    url = "https://cirrus.ucsd.edu/~pierce/ncview/ncview-${finalAttrs.version}.tar.gz";
    hash = "sha256-4jF6wJSvYvCtz2hCHXBlgglDaq40RkCVnsiXWmRYka8=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    netcdf
  ];

  buildInputs = [
    expat
    libpng
    netcdf
    udunits
    libice
    libsm
    libx11
    libxaw
    libxt
  ];

  meta = {
    description = "Visual browser for netCDF format files";
    homepage = "http://meteora.ucsd.edu/~pierce/ncview_home_page.html";
    license = lib.licenses.gpl3Plus;
    mainProgram = "ncview";
    maintainers = with lib.maintainers; [ jmettes ];
    platforms = lib.platforms.all;
  };
})
