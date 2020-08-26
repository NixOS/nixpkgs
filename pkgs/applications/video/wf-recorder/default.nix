{ stdenv, fetchFromGitHub, meson, ninja, pkg-config, wayland, scdoc
, wayland-protocols, ffmpeg, x264, libpulseaudio, ocl-icd, opencl-headers
}:

stdenv.mkDerivation rec {
  pname = "wf-recorder";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "ammen99";
    repo = pname;
    rev = "v${version}";
    sha256 = "1cw6kpcbl33wh95pvy32xrsrm6kkk1awccr3phyh885xjs3b3iim";
  };

  nativeBuildInputs = [ meson ninja pkg-config wayland scdoc ];
  buildInputs = [
    wayland-protocols ffmpeg x264 libpulseaudio ocl-icd opencl-headers
  ];

  meta = with stdenv.lib; {
    description = "Utility program for screen recording of wlroots-based compositors";
    inherit (src.meta) homepage;
    changelog = "https://github.com/ammen99/wf-recorder/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ primeos CrazedProgrammer ];
    platforms = platforms.linux;
  };
}
