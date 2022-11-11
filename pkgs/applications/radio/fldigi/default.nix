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
  version = "4.1.23";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${pname}-${version}.tar.gz";
    sha256 = "sha256-42bh/J/DQ/V9ORKKZgOmlvhyNR7UjbqPPD0Wi9ofyo0=";
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
