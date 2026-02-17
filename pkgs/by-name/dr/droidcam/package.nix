{
  lib,
  stdenv,
  fetchFromGitHub,
  ffmpeg,
  libjpeg_turbo,
  gtk3,
  alsa-lib,
  speex,
  libusbmuxd,
  libappindicator-gtk3,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "droidcam";
  version = "2.1.4";

  src = fetchFromGitHub {
    owner = "aramg";
    repo = "droidcam";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-z/SteW3jYR/VR+HffvTetdGs5oz4qWBNkaqLYiP1V8c=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    ffmpeg
    libjpeg_turbo
    gtk3
    alsa-lib
    speex
    libusbmuxd
    libappindicator-gtk3
  ];

  postPatch = ''
    substituteInPlace src/droidcam.c \
      --replace "/opt/droidcam-icon.png" "$out/share/icons/hicolor/96x96/apps/droidcam.png"
    substituteInPlace droidcam.desktop \
      --replace "/opt/droidcam-icon.png" "droidcam" \
      --replace "/usr/local/bin/droidcam" "droidcam"
  '';

  preBuild = ''
    makeFlagsArray+=("JPEG=$(pkg-config --libs --cflags libturbojpeg)")
    makeFlagsArray+=("USBMUXD=$(pkg-config --libs --cflags libusbmuxd-2.0)")
  '';

  installPhase = ''
    runHook preInstall

    install -Dt $out/bin droidcam droidcam-cli
    install -D icon2.png $out/share/icons/hicolor/96x96/apps/droidcam.png
    install -D droidcam.desktop $out/share/applications/droidcam.desktop

    runHook postInstall
  '';

  meta = {
    description = "Linux client for DroidCam app";
    homepage = "https://github.com/aramg/droidcam";
    license = lib.licenses.gpl2Only;
    maintainers = [ lib.maintainers.suhr ];
    platforms = lib.platforms.linux;
  };
})
