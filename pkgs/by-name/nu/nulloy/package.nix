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

stdenv.mkDerivation (finalAttrs: {
  pname = "nulloy";
  version = "0.9.9";

  src = fetchFromGitHub {
    owner = "nulloy";
    repo = "nulloy";
    rev = finalAttrs.version;
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

  meta = {
    description = "Music player with a waveform progress bar";
    homepage = "https://nulloy.com";
    changelog = "https://github.com/nulloy/nulloy/blob/${finalAttrs.src.rev}/ChangeLog";
    license = lib.licenses.gpl3Only;
    mainProgram = "nulloy";
    maintainers = with lib.maintainers; [ aleksana ];
    platforms = lib.platforms.all;
    broken = stdenv.hostPlatform.isDarwin;
  };
})
