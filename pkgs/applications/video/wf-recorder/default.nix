{ lib, stdenv, fetchFromGitHub
, meson, ninja, pkg-config, scdoc, wayland-scanner
, wayland, wayland-protocols, ffmpeg, x264, libpulseaudio
, mesa # for libgbm
}:

stdenv.mkDerivation rec {
  pname = "wf-recorder";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "ammen99";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-HSNogz99fh25bGnYrIFkQC8SZ/EjG9Ak1kQpVmSlliU=";
  };

  nativeBuildInputs = [ meson ninja pkg-config wayland-scanner scdoc ];
  buildInputs = [
    wayland wayland-protocols ffmpeg x264 libpulseaudio mesa
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
