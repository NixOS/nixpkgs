{
  cmake,
  fetchFromGitHub,
  ffmpeg-headless,
  lib,
  libjpeg,
  libpng,
  pkg-config,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ffmpegthumbnailer";
  version = "2.4.1";

  src = fetchFromGitHub {
    owner = "dirkvdb";
    repo = "ffmpegthumbnailer";
    tag = "v${finalAttrs.version}";
    hash = "sha256-LvurrguCs/NOs4pZ+zbvWFGJ25pYeKO9vblfwEtC/LE=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    ffmpeg-headless
    libjpeg
    libpng
  ];

  cmakeFlags = [
    "-DENABLE_THUMBNAILER=ON"
    "-DENABLE_AUDIO_THUMBNAILER=ON"
  ];

  # https://github.com/dirkvdb/ffmpegthumbnailer/issues/215
  postPatch = ''
    substituteInPlace libffmpegthumbnailer.pc.in \
      --replace '$'{exec_prefix}/@CMAKE_INSTALL_LIBDIR@ @CMAKE_INSTALL_FULL_LIBDIR@
  '';

  postInstall = ''
    substituteInPlace $out/share/thumbnailers/ffmpegthumbnailer{,-audio}.thumbnailer \
      --replace-fail '=ffmpegthumbnailer' "=$out/bin/ffmpegthumbnailer"
  '';

  meta = {
    description = "Lightweight video thumbnailer";
    longDescription = "FFmpegthumbnailer is a lightweight video
        thumbnailer that can be used by file managers to create thumbnails
        for your video files. The thumbnailer uses ffmpeg to decode frames
        from the video files, so supported video formats depend on the
        configuration flags of ffmpeg.
        This thumbnailer was designed to be as fast and lightweight as possible.
        The only dependencies are ffmpeg and libpng/libjpeg.
    ";
    homepage = "https://github.com/dirkvdb/ffmpegthumbnailer";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    mainProgram = "ffmpegthumbnailer";
    maintainers = with lib.maintainers; [ gaelj ];
  };
})
