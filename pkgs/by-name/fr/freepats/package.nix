{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "freepats";
  version = "20060219";

  src = fetchurl {
    url = "https://freepats.zenvoid.org/freepats-${finalAttrs.version}.tar.bz2";
    sha256 = "12iw36rd94zirll96cd5k0va7p5hxmf2shvjlhzihcmjaw8flq82";
  };

  installPhase = ''mkdir "$out"; cp -r . "$out"'';

  meta = {
    description = "Instrument patches, for MIDI synthesizers";
    longDescription = ''
      Freepats is a project to create a free and open set of instrument
      patches, in any format, that can be used with softsynths.
    '';
    homepage = "https://freepats.zenvoid.org/";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.bjornfor ];
  };
})
