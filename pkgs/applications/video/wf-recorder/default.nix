{ stdenv, fetchFromGitHub, meson, ninja, pkgconfig, wayland, wayland-protocols, ffmpeg, x264, libpulseaudio }:

stdenv.mkDerivation rec {
  pname = "wf-recorder";
  version = "unstable-2019-04-21";

  src = fetchFromGitHub {
    owner = "ammen99";
    repo = pname;
    rev = "ddb96690556371007e316577ed1b14f0cb62e13c";
    sha256 = "04amfd1kyklcj6nmmmf21dz333ykglvhxb3cbzak06v2fxlrp2w3";
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
