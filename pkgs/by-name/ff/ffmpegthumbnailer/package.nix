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

stdenv.mkDerivation rec {
  pname = "ffmpegthumbnailer";
  version = "unstable-2024-01-04";

  src = fetchFromGitHub {
    owner = "dirkvdb";
    repo = "ffmpegthumbnailer";
    rev = "1b5a77983240bcf00a4ef7702c07bcd8f4e5f97c";
    hash = "sha256-7SPRQMPgdvP7J3HCf7F1eXxZjUH5vCYZ9UOwTUFMLp0=";
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
}
