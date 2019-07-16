{ stdenv, fetchFromGitHub, meson, ninja, pkgconfig, wayland, wayland-protocols
, ffmpeg, x264, libpulseaudio
}:

stdenv.mkDerivation rec {
  pname = "wf-recorder";
  version = "0.1";

  src = fetchFromGitHub {
    owner = "ammen99";
    repo = pname;
    rev = "v${version}";
    sha256 = "1rl75r87ijja9mfyrwrsz8r4zvjnhm0103qmgyhq2phlrdpkks5d";
  };

  nativeBuildInputs = [ meson ninja pkgconfig ];
  buildInputs = [ wayland wayland-protocols ffmpeg x264 libpulseaudio ];

  meta = with stdenv.lib; {
    description = "Utility program for screen recording of wlroots-based compositors";
    homepage = https://github.com/ammen99/wf-recorder;
    license = licenses.mit;
    maintainers = with maintainers; [ CrazedProgrammer ];
    platforms = platforms.linux;
  };
}
