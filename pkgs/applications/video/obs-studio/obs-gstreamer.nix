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

  # obs-studio expects the shared object to be located in bin/32bit or bin/64bit
  # https://github.com/obsproject/obs-studio/blob/d60c736cb0ec0491013293c8a483d3a6573165cb/libobs/obs-nix.c#L48
  postInstall = let
    pluginPath = {
      i686-linux = "bin/32bit";
      x86_64-linux = "bin/64bit";
    }.${stdenv.targetPlatform.system} or (throw "Unsupported system: ${stdenv.targetPlatform.system}");
  in ''
    mkdir -p $out/share/obs/obs-plugins/obs-gstreamer/${pluginPath}
    ln -s $out/lib/obs-plugins/obs-gstreamer.so $out/share/obs/obs-plugins/obs-gstreamer/${pluginPath}
  '';

  meta = with lib; {
    description = "An OBS Studio source, encoder and video filter plugin to use GStreamer elements/pipelines in OBS Studio";
    homepage = "https://github.com/fswoch/obs-gstreamer";
    maintainers = with maintainers; [ ahuzik ];
    license = licenses.gpl2Plus;
    platforms = [ "x86_64-linux" "i686-linux" ];
  };
}
