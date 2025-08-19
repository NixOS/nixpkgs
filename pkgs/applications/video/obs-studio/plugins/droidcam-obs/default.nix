{
  lib,
  stdenv,
  fetchFromGitHub,
  obs-studio,
  ffmpeg,
  libjpeg,
  libimobiledevice,
  libusbmuxd,
  libplist,
  pkg-config,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "droidcam-obs";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "dev47apps";
    repo = "droidcam-obs-plugin";
    tag = finalAttrs.version;
    sha256 = "sha256-rA+EMtAeM2LSUqtiYJt0hHZ85aZ+5bvVUUjIG2LC3pc=";
  };

  preBuild = ''
    mkdir ./build
  '';

  buildInputs = [
    libjpeg
    libimobiledevice
    libusbmuxd
    libplist
    obs-studio
    ffmpeg
  ];

  nativeBuildInputs = [
    pkg-config
  ];

  # Flag reference in regard to:
  # https://github.com/dev47apps/droidcam-obs-plugin/blob/master/linux/linux.mk
  makeFlags = [
    "ALLOW_STATIC=no"
    "JPEG_DIR=${lib.getDev libjpeg}"
    "JPEG_LIB=${lib.getLib libjpeg}/lib"
    "IMOBILEDEV_DIR=${lib.getDev libimobiledevice}"
    "IMOBILEDEV_DIR=${lib.getLib libimobiledevice}"
    "LIBOBS_INCLUDES=${obs-studio}/include/obs"
    "FFMPEG_INCLUDES=${lib.getLib ffmpeg}"
    "LIBUSBMUXD=libusbmuxd-2.0"
    "LIBIMOBILEDEV=libimobiledevice-1.0"
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/obs/obs-plugins/droidcam-obs
    mkdir -p $out/lib/obs-plugins
    cp build/droidcam-obs.so $out/lib/obs-plugins
    cp -R ./data/locale $out/share/obs/obs-plugins/droidcam-obs/locale

    runHook postInstall
  '';

  doCheck = false;

  meta = {
    description = "DroidCam OBS";
    homepage = "https://github.com/dev47apps/droidcam-obs-plugin";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ NotAShelf ];
    platforms = lib.platforms.linux;
  };
})
