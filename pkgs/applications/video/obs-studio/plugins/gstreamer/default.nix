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
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "fzwoch";
    repo = "obs-gstreamer";
    rev = "v${version}";
    hash = "sha256-KhSBZcV2yILTf5+aNoYWDfNwPiJoyYPeIOQMDFvOusg=";
  };

  nativeBuildInputs = [ pkg-config meson ninja ];
  buildInputs = with gst_all_1; [ gstreamer gst-plugins-base obs-studio ];

  meta = with lib; {
    description = "An OBS Studio source, encoder and video filter plugin to use GStreamer elements/pipelines in OBS Studio";
    homepage = "https://github.com/fzwoch/obs-gstreamer";
    maintainers = with maintainers; [ ahuzik ];
    license = licenses.gpl2Plus;
    platforms = [ "x86_64-linux" "i686-linux" ];
  };
}
