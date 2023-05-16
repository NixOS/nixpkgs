{ lib
, stdenv
, fetchurl
, hamlib
, fltk13
, libjpeg
, libpng
, portaudio
, libsndfile
, libsamplerate
, libpulseaudio
, libXinerama
, gettext
, pkg-config
, alsa-lib
, udev
}:

stdenv.mkDerivation rec {
  pname = "fldigi";
<<<<<<< HEAD
  version = "4.2.00";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${pname}-${version}.tar.gz";
    hash = "sha256-F09C6R3mEgYVhS7/MqEBFzfqGKbyrAem5/+QDlwI+9k=";
=======
  version = "4.1.26";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${pname}-${version}.tar.gz";
    sha256 = "sha256-RIrTWjQPnn0I8bzV3kMQEesNaAkIQnhikLMaYivrWRc=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libXinerama
    gettext
    hamlib
    fltk13
    libjpeg
    libpng
    portaudio
    libsndfile
    libsamplerate
  ] ++ lib.optionals (stdenv.isLinux) [ libpulseaudio alsa-lib udev ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Digital modem program";
    homepage = "https://sourceforge.net/projects/fldigi/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ relrod ftrvxmtrx ];
    platforms = platforms.unix;
    # unable to execute command: posix_spawn failed: Argument list too long
    # Builds fine on aarch64-darwin
    broken = stdenv.system == "x86_64-darwin";
  };
}
