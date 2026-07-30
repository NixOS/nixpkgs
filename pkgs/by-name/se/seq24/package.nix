{
  lib,
  stdenv,
  fetchurl,
  alsa-lib,
  gtkmm2,
  libjack2,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "seq24";
  version = "0.9.3";

  src = fetchurl {
    url = "https://launchpad.net/seq24/trunk/${finalAttrs.version}/+download/seq24-${finalAttrs.version}.tar.gz";
    sha256 = "1qpyb7355s21sgy6gibkybxpzx4ikha57a8w644lca6qy9mhcwi3";
  };

  patches = [ ./mutex_no_nameclash.patch ];

  buildInputs = [
    alsa-lib
    gtkmm2
    libjack2
  ];
  nativeBuildInputs = [ pkg-config ];

  meta = {
    description = "Minimal loop based midi sequencer";
    homepage = "http://www.filter24.org/seq24";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
    maintainers = [ ];
    mainProgram = "seq24";
  };
})
