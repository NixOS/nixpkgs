{ stdenv, lib, fetchFromGitHub, pkg-config, meson, ninja, wayland, pixman, cairo, librsvg, wayland-protocols, wlroots, libxkbcommon, gst_all_1, wrapQtAppsHook, qtbase, qtmultimedia }:
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
  version = "2020-08-03";

  src = fetchFromGitHub {
    owner = "xdavidwu";
    repo = "qt-video-wlr";
    rev = "f88a7aa43f28b879b18752069f4a1ec33d73f2fe";
    sha256 = "135kfyg1b61xvfpk8vpk4qyw6s9q1mn3a6lfkrqrhl0dz9kka9lx";
  };

  nativeBuildInputs = [ pkg-config meson ninja wrapQtAppsHook ];
  buildInputs = [
      wayland
      pixman
      cairo
      librsvg
      wayland-protocols
      wlroots
      libxkbcommon
      qtbase
      qtmultimedia
  ];

  qtWrapperArgs = [
      "--prefix PATH : $out/bin/qt-video-wlr"
      "--prefix GST_PLUGIN_PATH : ${gstreamerPath}"
  ];

  meta = with lib; {
    description = "Qt pip-mode-like video player for wlroots-based wayland compositors";
    homepage = "https://github.com/xdavidwu/qt-video-wlr";
    license = licenses.mit;
    maintainers = with maintainers; [ fionera ];
    platforms = with platforms; linux;
  };
}
