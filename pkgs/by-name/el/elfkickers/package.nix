{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "elfkickers";
  version = "3.2";

  src = fetchurl {
    url = "https://www.muppetlabs.com/~breadbox/pub/software/ELFkickers-${version}.tar.gz";
    sha256 = "sha256-m4HmxT4MlPwZjZiC63NxVvNtVlFS3DIRiJfHewaiaHw=";
  };

  makeFlags = [ "CC=${stdenv.cc.targetPrefix}cc" "prefix:=${placeholder "out"}" ];

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://www.muppetlabs.com/~breadbox/software/elfkickers.html";
    description = "Collection of programs that access and manipulate ELF files";
    platforms = platforms.linux;
    license = licenses.gpl2Plus;
    maintainers = [ ];
  };
}
