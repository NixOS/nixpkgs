{
  lib,
  stdenv,
  fetchurl,
  cmake,
  libjpeg,
  libpng,
  libtiff,
  perl,
  darwin,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libpano13";
  version = "2.9.22";

  src = fetchurl {
    url = "mirror://sourceforge/panotools/libpano13-${finalAttrs.version}.tar.gz";
    hash = "sha256-r/xoMM2+ccKNJzHcv43qKs2m2f/UYJxtvzugxoRAqOM=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    perl
  ];

  buildInputs =
    [
      libjpeg
      libpng
      libtiff
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      darwin.apple_sdk.frameworks.Carbon
    ];

  meta = with lib; {
    description = "Free software suite for authoring and displaying virtual reality panoramas";
    homepage = "https://panotools.sourceforge.net/";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.wegank ];
    platforms = platforms.unix;
  };
})
