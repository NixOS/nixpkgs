{ stdenv, lib, fetchFromGitHub, pkg-config, meson, cmake, ninja, gst_all_1, wrapQtAppsHook, qtbase, qtmultimedia, layer-shell-qt }:
let
 gstreamerPath = with gst_all_1; lib.makeSearchPathOutput "lib" "lib/gstreamer-1.0" [
     gstreamer
     gst-plugins-base
     gst-plugins-good
     gst-plugins-bad
     gst-plugins-ugly
 ];
in stdenv.mkDerivation rec {
  pname = "qt-video-wlr";
  version = "2023-07-22";

  src = fetchFromGitHub {
    owner = "xdavidwu";
    repo = "qt-video-wlr";
    rev = "1373c8eeb0a5d867927ba30a9a9bb2d5b0057a87";
    hash = "sha256-mg0ROD9kV88I5uCm+niAI5tJuhkmYC7Z8dixxrNow4c=";
  };

  nativeBuildInputs = [
    pkg-config
    meson
    cmake # only used for find layer-shell-qt
    ninja
    wrapQtAppsHook
  ];

  buildInputs = [
    qtbase
    qtmultimedia
    layer-shell-qt
  ];

  qtWrapperArgs = [
    "--prefix PATH : $out/bin/qt-video-wlr"
    "--prefix GST_PLUGIN_PATH : ${gstreamerPath}"
  ];

  meta = with lib; {
    description = "Qt pip-mode-like video player for wlroots-based wayland compositors";
    homepage = "https://github.com/xdavidwu/qt-video-wlr";
    license = licenses.mit;
    maintainers = with maintainers; [ fionera rewine ];
    platforms = with platforms; linux;
  };
}
