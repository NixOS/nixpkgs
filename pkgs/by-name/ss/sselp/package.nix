{
  lib,
  stdenv,
  fetchurl,
  libx11,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "0.2";
  pname = "sselp";

  src = fetchurl {
    url = "https://dl.suckless.org/tools/sselp-${finalAttrs.version}.tar.gz";
    sha256 = "08mqp00lrh1chdrbs18qr0xv63h866lkmfj87kfscwdm1vn9a3yd";
  };

  buildInputs = [ libx11 ];

  patchPhase = ''
    sed -i "s@/usr/local@$out@g" config.mk
    sed -i "s@/usr/X11R6/include@${libx11}/include@g" config.mk
    sed -i "s@/usr/X11R6/lib@${libx11}/lib@g" config.mk
  '';

  meta = {
    homepage = "https://tools.suckless.org/sselp";
    description = "Prints the X selection to stdout, useful in scripts";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.magnetophon ];
    platforms = lib.platforms.linux;
    mainProgram = "sselp";
  };
})
