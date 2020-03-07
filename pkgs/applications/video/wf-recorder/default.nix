{ stdenv, fetchFromGitHub, meson, ninja, pkg-config, wayland, scdoc
, wayland-protocols, ffmpeg_4, x264, libpulseaudio, ocl-icd, opencl-headers
}:

stdenv.mkDerivation rec {
  pname = "wf-recorder";
  version = "0.2";

  src = fetchFromGitHub {
    owner = "ammen99";
    repo = pname;
    rev = "v${version}";
    sha256 = "1772hrd7j8b32y65x5c392kdijlcn13iqg9hrlagfar92102vsbf";
  };

  nativeBuildInputs = [ meson ninja pkg-config wayland scdoc ];
  buildInputs = [
    wayland-protocols ffmpeg_4 x264 libpulseaudio ocl-icd opencl-headers
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
