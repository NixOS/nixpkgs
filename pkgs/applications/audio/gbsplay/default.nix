{ stdenv, fetchFromGitHub, libpulseaudio }:

stdenv.mkDerivation {
  name = "gbsplay-2016-12-17";

  src = fetchFromGitHub {
    owner = "mmitch";
    repo = "gbsplay";
    rev = "2c4486e17fd4f4cdea8c3fd79ae898c892616b70";
    sha256 = "1214j67sr87zfhvym41cw2g823fmqh4hr451r7y1s9ql3jpjqhpz";
  };

  buildInputs = [ libpulseaudio ];

  configureFlags =
   [ "--without-test" "--without-contrib" "--disable-devdsp"
     "--enable-pulse" "--disable-alsa" "--disable-midi"
     "--disable-nas" "--disable-dsound" "--disable-i18n" ];

  makeFlags = [ "tests=" ];

  meta = with stdenv.lib; {
    description = "gameboy sound player";
    license = licenses.gpl1;
    platforms = ["i686-linux" "x86_64-linux"];
    maintainers = with maintainers; [ dasuxullebt ];
  };
}
