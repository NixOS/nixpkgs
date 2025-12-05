{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  pkg-config,
  ffmpeg-headless,
  libpng,
  libjpeg,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ffmpegthumbnailer";
  version = "2.2.3";

  src = fetchFromGitHub {
    owner = "dirkvdb";
    repo = "ffmpegthumbnailer";
    tag = finalAttrs.version;
    hash = "sha256-1hVPtCPwfovCtA6aagViUJkYTCFuiFkOqGEqMHIoZe8=";
  };

  patches = [
    (fetchpatch {
      name = "ffmpeg-8-fix.patch";
      url = "https://github.com/dirkvdb/ffmpegthumbnailer/commit/df789ec326ae0f2c619f91c8f2fc8b5e45b50a70.patch";
      hash = "sha256-PArrcKuaWWA6/H59MbdC36B57GSvvp5sHz24QLTBZYw=";
    })
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    ffmpeg-headless
    libpng
    libjpeg
  ];

  cmakeFlags = [ "-DENABLE_THUMBNAILER=ON" ];

  # https://github.com/dirkvdb/ffmpegthumbnailer/issues/215
  postPatch = ''
    substituteInPlace libffmpegthumbnailer.pc.in \
      --replace '$'{exec_prefix}/@CMAKE_INSTALL_LIBDIR@ @CMAKE_INSTALL_FULL_LIBDIR@
  '';

  postInstall = ''
    substituteInPlace $out/share/thumbnailers/ffmpegthumbnailer.thumbnailer \
      --replace-fail '=ffmpegthumbnailer' "=$out/bin/ffmpegthumbnailer"
  '';

  meta = with lib; {
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
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.jagajaga ];
    platforms = platforms.unix;
    mainProgram = "ffmpegthumbnailer";
  };
})
