{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  wrapGAppsHook3,
  gst_all_1,
  gtk3,
  ncurses,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gst123";
  version = "0.4.1-unstable-2025-11-28";

  src = fetchFromGitHub {
    owner = "swesterfeld";
    repo = "gst123";
    rev = "3680535cb5ab12d9bfba8f7de8cf9a83fb01fe22";
    hash = "sha256-+thGzcmBQanj7fGRImWk4PVRFBFLVHYQIP1HYoUzglk=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    gtk3
    ncurses
  ]
  ++ (with gst_all_1; [
    gstreamer
    gst-plugins-base
    gst-plugins-good
    gst-plugins-bad
    gst-plugins-ugly
    gst-libav
  ]);

  enableParallelBuilding = true;

  meta = {
    broken = stdenv.hostPlatform.isDarwin;
    description = "GStreamer based command line media player";
    homepage = "https://space.twc.de/~stefan/gst123.php";
    license = lib.licenses.lgpl2Plus;
    mainProgram = "gst123";
    maintainers = with lib.maintainers; [ swesterfeld ];
    inherit (ncurses.meta) platforms;
  };
})
