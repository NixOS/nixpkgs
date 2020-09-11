{ lib
, stdenv
, fetchFromGitHub
, gstreamer
, gst-plugins-base
, pkgconfig
, meson
, ninja
, obs-studio
}:

stdenv.mkDerivation rec {
  pname = "obs-gstreamer";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "fzwoch";
    repo = "obs-gstreamer";
    rev = "v${version}";
    sha256 = "1szfx5p2lb953blzw7prfd0nngjlwv2wn7jmnwvlssc9ci6jl6s8";
  };

  nativeBuildInputs = [ meson ninja pkgconfig ];
  buildInputs = [ obs-studio gstreamer gst-plugins-base ];

  meta = with lib; {
    description = "GStreamer OBS Studio plugin";
    homepage = "https://github.com/fzwoch/obs-gstreamer";
    license = licenses.gpl2;
    maintainers = with maintainers; [ yurkobb ];
    platforms = [ "x86_64-linux" "i686-linux" ];
  };
}
