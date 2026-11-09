{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "elfkickers";
  version = "3.2";

  src = fetchurl {
    url = "https://www.muppetlabs.com/~breadbox/pub/software/ELFkickers-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-m4HmxT4MlPwZjZiC63NxVvNtVlFS3DIRiJfHewaiaHw=";
  };

  makeFlags = [
    "CC=${stdenv.cc.targetPrefix}cc"
    "prefix:=${placeholder "out"}"
  ];

  enableParallelBuilding = true;

  meta = {
    homepage = "https://www.muppetlabs.com/~breadbox/software/elfkickers.html";
    description = "Collection of programs that access and manipulate ELF files";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
  };
})
