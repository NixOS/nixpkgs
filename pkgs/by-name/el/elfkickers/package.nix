{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "elfkickers";
  version = "3.2";

  src = fetchurl {
    url = "https://www.muppetlabs.com/~breadbox/pub/software/ELFkickers-${version}.tar.gz";
    sha256 = "sha256-m4HmxT4MlPwZjZiC63NxVvNtVlFS3DIRiJfHewaiaHw=";
  };

  makeFlags = [
    "CC=${stdenv.cc.targetPrefix}cc"
    "prefix:=${placeholder "out"}"
  ];

  enableParallelBuilding = true;

<<<<<<< HEAD
  meta = {
    homepage = "https://www.muppetlabs.com/~breadbox/software/elfkickers.html";
    description = "Collection of programs that access and manipulate ELF files";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl2Plus;
=======
  meta = with lib; {
    homepage = "https://www.muppetlabs.com/~breadbox/software/elfkickers.html";
    description = "Collection of programs that access and manipulate ELF files";
    platforms = platforms.linux;
    license = licenses.gpl2Plus;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
  };
}
