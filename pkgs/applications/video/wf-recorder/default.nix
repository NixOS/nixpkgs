{ lib, stdenv, fetchFromGitHub
, meson, ninja, pkg-config, scdoc, wayland-scanner
, wayland, wayland-protocols, ffmpeg, x264, libpulseaudio, ocl-icd, opencl-headers
}:

stdenv.mkDerivation rec {
  pname = "wf-recorder";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "ammen99";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-othFp97rUrdUoAXkup8VvpcyPHs5iYNFyRE3h3rcmqE=";
  };

  nativeBuildInputs = [ meson ninja pkg-config wayland-scanner scdoc ];
  buildInputs = [
    wayland wayland-protocols ffmpeg x264 libpulseaudio ocl-icd opencl-headers
  ];

  meta = with lib; {
    description = "Utility program for screen recording of wlroots-based compositors";
    inherit (src.meta) homepage;
    changelog = "https://github.com/ammen99/wf-recorder/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ yuka ];
    platforms = platforms.linux;
  };
}
