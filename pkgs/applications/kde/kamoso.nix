{ mkDerivation
, lib
, extra-cmake-modules
, kdoctools
, wrapQtAppsHook
, qtdeclarative
, qtgraphicaleffects
, qtquickcontrols2
, kirigami2
, kpurpose
, gst_all_1
, pcre
}:

let
  gst = with gst_all_1; [ gstreamer gst-libav gst-plugins-base gst-plugins-good gst-plugins-bad ];

in
mkDerivation {
  pname = "kamoso";
  nativeBuildInputs = [ extra-cmake-modules kdoctools wrapQtAppsHook ];
  buildInputs = [ pcre ] ++ gst;
  propagatedBuildInputs = [
    qtdeclarative
    qtgraphicaleffects
    qtquickcontrols2
    kirigami2
    kpurpose
  ];

  cmakeFlags = [
    "-DOpenGL_GL_PREFERENCE=GLVND"
    "-DGSTREAMER_VIDEO_INCLUDE_DIR=${gst_all_1.gst-plugins-base.dev}/include/gstreamer-1.0"
  ];

  qtWrapperArgs = [
    "--prefix GST_PLUGIN_PATH : ${lib.makeSearchPathOutput "lib" "lib/gstreamer-1.0" gst}"
  ];

  meta = {
    homepage = "https://apps.kde.org/kamoso/";
    description = "Simple and friendly program to use your camera";
    mainProgram = "kamoso";
    license = with lib.licenses; [ lgpl21Only gpl3Only ];
  };
}
