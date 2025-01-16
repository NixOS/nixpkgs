{
  lib,
  stdenv,
  fetchurl,
  imagemagick,
  libpng,
}:

stdenv.mkDerivation {
  pname = "optar";
  version = "20150210";

  src = fetchurl {
    url = "http://ronja.twibright.com/optar.tgz";
    hash = "sha256-RIVqm6uwfmvhTIiAIISeb8gD71KDrtm3UZe5PmYYmYI=";
  };

  buildInputs = [ libpng ];

  enableParallelBuilding = true;

  postPatch = ''
    substituteInPlace Makefile \
      --replace /usr/local $out

    substituteInPlace pgm2ps \
      --replace 'convert ' "${lib.getBin imagemagick}/bin/convert "
  '';

  preInstall = ''
    mkdir -p $out/bin
  '';

  # gcc14 is more strict
  env.NIX_CFLAGS_COMPILE = toString [
    "-Wno-error=implicit-int"
  ];

  meta = with lib; {
    description = "OPTical ARchiver - it's a codec for encoding data on paper";
    homepage = "http://ronja.twibright.com/optar/";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ peterhoeg ];
    platforms = with platforms; linux; # possibly others, but only tested on Linux
    mainProgram = "optar";
  };
}
