{ lib, stdenv, fetchurl, pkg-config, alsa-lib, libxmp, AudioUnit, CoreAudio }:

stdenv.mkDerivation rec {
  pname = "xmp";
  version = "4.1.0";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${pname}/${pname}-${version}.tar.gz";
    sha256 = "17i8fc7x7yn3z1x963xp9iv108gxfakxmdgmpv3mlm438w3n3g8x";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libxmp ]
    ++ lib.optionals stdenv.isLinux [ alsa-lib ]
    ++ lib.optionals stdenv.isDarwin [ AudioUnit CoreAudio ];

  meta = with lib; {
    description = "Extended module player";
    homepage    = "https://xmp.sourceforge.net/";
    license     = licenses.gpl2Plus;
    platforms   = platforms.unix;
  };
}
