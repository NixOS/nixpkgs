{ lib
, stdenv
, fetchFromGitHub
, gst_all_1
, pkg-config
, meson
, ninja
, obs-studio
}:

stdenv.mkDerivation rec {
  pname = "obs-gstreamer";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "fzwoch";
    repo = "obs-gstreamer";
    rev = "v${version}";
    sha256 = "1fdpwr8br8x9cnrhr3j4f0l81df26n3bj2ibi3cg96rl86054nid";
  };

  nativeBuildInputs = [ pkg-config meson ninja ];
  buildInputs = [ gst_all_1.gstreamermm obs-studio ];

  meta = with lib; {
    description = "An OBS Studio source, encoder and video filter plugin to use GStreamer elements/pipelines in OBS Studio";
    homepage = "https://github.com/fswoch/obs-gstreamer";
    maintainers = with maintainers; [ ahuzik ];
    license = licenses.gpl2Plus;
    platforms = [ "x86_64-linux" "i686-linux" ];
  };
}
