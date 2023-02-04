{ lib
, stdenv
, fetchFromGitHub
, obs-studio
, ffmpeg
, libjpeg
, libimobiledevice
, libusbmuxd
, libplist
}:

stdenv.mkDerivation rec {
  pname = "droidcam-obs";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "dev47apps";
    repo = "droidcam-obs-plugin";
    rev = version;
    sha256 = "sha256-oaw/mq4WCQMlf3sv9WtNlv9J9rm79xnqDwKzHtyFW50=";
  };

  postPatch = ''
    substituteInPlace ./linux/linux.mk \
      --replace "-limobiledevice" "-limobiledevice-1.0" \
      --replace "-I/usr/include/obs" "-I${obs-studio}/include/obs" \
      --replace "-I/usr/include/ffmpeg" "-I${ffmpeg}/include"
  '';

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

  meta = with lib; {
    description = "DroidCam OBS";
    homepage = "https://github.com/dev47apps/droidcam-obs-plugin";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ ulrikstrid ];
    platforms = platforms.linux;
  };
}
