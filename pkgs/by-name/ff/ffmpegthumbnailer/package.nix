{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  ffmpeg-headless,
  libpng,
  libjpeg,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ffmpegthumbnailer";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "dirkvdb";
    repo = "ffmpegthumbnailer";
    tag = "v${finalAttrs.version}";
    hash = "sha256-h8B12FItvSrYgy6t78A02DL96Az4BxtW8brFKkZLH9o=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    ffmpeg-headless
    libpng
    libjpeg
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
    substituteInPlace $out/share/thumbnailers/ffmpegthumbnailer.thumbnailer \
      --replace-fail '=ffmpegthumbnailer' "=$out/bin/ffmpegthumbnailer"
  '';

  meta = {
    description = "Lightweight video thumbnailer";
    longDescription = "FFmpegthumbnailer is a lightweight video
        thumbnailer that can be used by file managers to create thumbnails
        for your video files. The thumbnailer uses ffmpeg to decode frames
        from the video files, so supported videoformats depend on the
        configuration flags of ffmpeg.
        This thumbnailer was designed to be as fast and lightweight as possible.
        The only dependencies are ffmpeg and libpng/libjpeg.
    ";
    homepage = "https://github.com/dirkvdb/ffmpegthumbnailer";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    mainProgram = "ffmpegthumbnailer";
  };
})
