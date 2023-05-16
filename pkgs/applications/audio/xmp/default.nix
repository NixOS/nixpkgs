<<<<<<< HEAD
{ lib, stdenv, fetchFromGitHub, autoreconfHook, pkg-config, alsa-lib, libxmp, AudioUnit, CoreAudio }:

stdenv.mkDerivation rec {
  pname = "xmp";
  version = "4.2.0";

  src = fetchFromGitHub {
    owner = "libxmp";
    repo = "xmp-cli";
    rev = "${pname}-${version}";
    hash = "sha256-037k1rFjGR6XFtr08bzs4zVz+GyUGuuutuWFlNEuATA=";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];
=======
{ lib, stdenv, fetchurl, pkg-config, alsa-lib, libxmp, AudioUnit, CoreAudio }:

stdenv.mkDerivation rec {
  pname = "xmp";
  version = "4.1.0";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${pname}/${pname}-${version}.tar.gz";
    sha256 = "17i8fc7x7yn3z1x963xp9iv108gxfakxmdgmpv3mlm438w3n3g8x";
  };

  nativeBuildInputs = [ pkg-config ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
