{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, pkg-config
, wrapGAppsHook
, gst_all_1
, gtk3
, ncurses
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gst123";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "swesterfeld";
    repo = "gst123";
    rev = finalAttrs.version;
    hash = "sha256-7qS7JJ7EY1uFGX3FxBxgH6LzK4XUoTPHR0QVwUWRz+g=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    wrapGAppsHook
  ];

  buildInputs = [
    gtk3
    ncurses
  ] ++ (with gst_all_1; [
    gstreamer
    gst-plugins-base
    gst-plugins-good
    gst-plugins-bad
    gst-plugins-ugly
    gst-libav
  ]);

  enableParallelBuilding = true;

  meta = {
    broken = stdenv.isDarwin;
    description = "GStreamer based command line media player";
    homepage = "https://space.twc.de/~stefan/gst123.php";
    license = lib.licenses.lgpl2Plus;
    mainProgram = "gst123";
    maintainers = with lib.maintainers; [ swesterfeld ];
    inherit (ncurses.meta) platforms;
  };
})
