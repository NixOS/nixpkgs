{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mingetty";
  version = "1.08";

  src = fetchurl {
    url = "mirror://sourceforge/mingetty/mingetty-${finalAttrs.version}.tar.gz";
    sha256 = "05yxrp44ky2kg6qknk1ih0kvwkgbn9fbz77r3vci7agslh5wjm8g";
  };

  makeFlags = [
    "CC:=$(CC)"
    "SBINDIR=${placeholder "out"}/sbin"
    "MANDIR=${placeholder "out"}/share/man/man8"
  ];

  preInstall = ''
    mkdir -p $out/sbin $out/share/man/man8
  '';

  meta = {
    homepage = "https://sourceforge.net/projects/mingetty";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
})
