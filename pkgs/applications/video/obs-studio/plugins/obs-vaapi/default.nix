{ lib
, stdenv
, fetchFromGitHub
, gst_all_1
, pciutils
, pkg-config
, meson
, ninja
, obs-studio
}:

stdenv.mkDerivation rec {
  pname = "obs-vaapi";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "fzwoch";
    repo = pname;
    rev = version;
    hash = "sha256-wrbVuqIe+DY3R+Jp3zCy2Uw3fv5ejYHtRV2Sv+y/n0w=";
  };

  nativeBuildInputs = [ pkg-config meson ninja ];
  buildInputs = with gst_all_1; [ gstreamer gst-plugins-base obs-studio pciutils ];

  # - We need "getLib" instead of default derivation, otherwise it brings gstreamer-bin;
  # - without gst-plugins-base it won't even show proper errors in logs;
  # - Without gst-plugins-bad it won't find element "vapostproc";
  # - gst-vaapi adds "VA-API" to "Encoder type";
  # Tip: "could not link appsrc to videoconvert1" can mean a lot of things, enable GST_DEBUG=2 for help.
  passthru.obsWrapperArguments =
    let
      gstreamerHook = package: "--prefix GST_PLUGIN_SYSTEM_PATH_1_0 : ${lib.getLib package}/lib/gstreamer-1.0";
    in
    with gst_all_1; builtins.map gstreamerHook [
      gstreamer
      gst-plugins-base
      gst-plugins-bad
      gst-vaapi
    ];

  # Fix output directory
  postInstall = ''
    mkdir $out/lib/obs-plugins
    mv $out/lib/obs-vaapi.so $out/lib/obs-plugins/
  '';

  meta = with lib; {
    description = "OBS Studio VAAPI support via GStreamer";
    homepage = "https://github.com/fzwoch/obs-vaapi";
    maintainers = with maintainers; [ ahuzik pedrohlc ];
    license = licenses.gpl2Plus;
    platforms = [ "x86_64-linux" "i686-linux" ];
  };
}
