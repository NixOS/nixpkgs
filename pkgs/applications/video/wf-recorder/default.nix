{ lib, stdenv, fetchFromGitHub
, meson, ninja, pkg-config, scdoc, wayland-scanner
<<<<<<< HEAD
, wayland, wayland-protocols, ffmpeg, x264, libpulseaudio
, mesa # for libgbm
=======
, wayland, wayland-protocols, ffmpeg, x264, libpulseaudio, ocl-icd, opencl-headers
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

stdenv.mkDerivation rec {
  pname = "wf-recorder";
<<<<<<< HEAD
  version = "0.4.1";
=======
  version = "0.3.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "ammen99";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-SXPXvKXn236oO1WakkMNql3lj2flYYlmArVHGomH0/k=";
=======
    sha256 = "sha256-othFp97rUrdUoAXkup8VvpcyPHs5iYNFyRE3h3rcmqE=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ meson ninja pkg-config wayland-scanner scdoc ];
  buildInputs = [
<<<<<<< HEAD
    wayland wayland-protocols ffmpeg x264 libpulseaudio mesa
=======
    wayland wayland-protocols ffmpeg x264 libpulseaudio ocl-icd opencl-headers
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
