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
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "droidcam-obs";
  version = "2.3.4";

  src = fetchFromGitHub {
    owner = "dev47apps";
    repo = "droidcam-obs-plugin";
    tag = finalAttrs.version;
    sha256 = "sha256-KWMLhddK561xA+EjvoG4tXRW4xoLil31JcTTfppblmA=";
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

  makeFlags = [
    "ALLOW_STATIC=no"
    "JPEG_DIR=${lib.getDev libjpeg}"
    "JPEG_LIB=${lib.getLib libjpeg}/lib"
    "IMOBILEDEV_DIR=${libimobiledevice}"
    "LIBOBS_INCLUDES=${obs-studio}/include/obs"
    "FFMPEG_INCLUDES=${lib.getLib ffmpeg}"
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
    maintainers = with lib.maintainers; [ ulrikstrid ];
    platforms = lib.platforms.linux;
  };
})
