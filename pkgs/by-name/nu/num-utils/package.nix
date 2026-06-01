{
  lib,
  stdenv,
  fetchurl,
  perl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "num-utils";
  version = "0.5";

  src = fetchurl {
    url = "https://suso.suso.org/programs/num-utils/downloads/num-utils-${finalAttrs.version}.tar.gz";
    sha256 = "0kn6yskjww2agcqvas5l2xp55mp4njdxqkdicchlji3qzih2fn83";
  };

  buildInputs = [ perl ];

  patchPhase = ''
    substituteInPlace Makefile --replace "-o 0 -g 0" "" --replace "\$(RPMDIR)" ""
  '';
  makeFlags = [
    "TOPDIR=${placeholder "out"}"
    "PERL=${perl}/bin/perl"
  ];

  meta = {
    description = "Programs for dealing with numbers from the command line";
    homepage = "https://suso.suso.org/xulu/Num-utils";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.all;
  };
})
