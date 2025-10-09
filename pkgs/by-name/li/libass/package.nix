{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  yasm,
  freetype,
  fribidi,
  harfbuzz,
  fontconfigSupport ? true,
  fontconfig ? null, # fontconfig support
  largeTilesSupport ? false, # Use larger tiles in the rasterizer
  libiconv,
}:

assert fontconfigSupport -> fontconfig != null;

stdenv.mkDerivation rec {
  pname = "libass";
  version = "0.17.4";

  src = fetchurl {
    url = "https://github.com/libass/libass/releases/download/${version}/${pname}-${version}.tar.xz";
    hash = "sha256-ePEXm4ONAl6cJuj+8z+AkvZWEURP+hv8DPrGozURoFo=";
  };

  outputs = [
    "out"
    "dev"
  ];

  configureFlags = [
    (lib.enableFeature fontconfigSupport "fontconfig")
    (lib.enableFeature largeTilesSupport "large-tiles")
  ];

  nativeBuildInputs = [
    pkg-config
    yasm
  ];

  buildInputs = [
    freetype
    fribidi
    harfbuzz
  ]
  ++ lib.optional fontconfigSupport fontconfig
  ++ lib.optional stdenv.hostPlatform.isDarwin [
    libiconv
  ];

  meta = with lib; {
    description = "Portable ASS/SSA subtitle renderer";
    homepage = "https://github.com/libass/libass";
    license = licenses.isc;
    platforms = platforms.unix;
    maintainers = with maintainers; [ codyopel ];
  };
}
