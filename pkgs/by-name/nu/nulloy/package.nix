{
  lib,
  stdenv,
  fetchFromGitHub,
  which,
  pkg-config,
  zip,
  imagemagick,
  qt5,
  taglib,
  gst_all_1,
}:

stdenv.mkDerivation rec {
  pname = "nulloy";
  version = "0.9.9";

  src = fetchFromGitHub {
    owner = "nulloy";
    repo = "nulloy";
    rev = version;
    hash = "sha256-vFg789vBV7ks+4YiWWl3u0/kQjzpAiX8dMfXU0hynDM=";
  };

  nativeBuildInputs = [
    which # used by configure script
    pkg-config
    zip
    imagemagick
    qt5.qttools
    qt5.wrapQtAppsHook
  ];

  buildInputs = [
    qt5.qtscript
    qt5.qtsvg
    taglib
  ]
  ++ (with gst_all_1; [
    gstreamer
    gst-plugins-base
    gst-plugins-good
    gst-plugins-bad
    gst-plugins-ugly
  ]);

  prefixKey = "--prefix ";

  enableParallelBuilding = true;

  # FIXME: not added by gstreamer setup hook by default
  preFixup = ''
    qtWrapperArgs+=(
      --prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "$GST_PLUGIN_SYSTEM_PATH_1_0"
    )
  '';

  meta = with lib; {
    description = "Music player with a waveform progress bar";
    homepage = "https://nulloy.com";
    changelog = "https://github.com/nulloy/nulloy/blob/${src.rev}/ChangeLog";
    license = licenses.gpl3Only;
    mainProgram = "nulloy";
    maintainers = with maintainers; [ aleksana ];
    platforms = platforms.all;
    broken = stdenv.hostPlatform.isDarwin;
  };
}
