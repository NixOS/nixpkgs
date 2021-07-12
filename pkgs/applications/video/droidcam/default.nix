{ lib, stdenv, fetchFromGitHub
, ffmpeg, libjpeg_turbo, gtk3, alsa-lib, speex, libusbmuxd, libappindicator-gtk3
, pkg-config
}:

stdenv.mkDerivation rec {
  pname = "droidcam";
  version = "1.7.3";

  src = fetchFromGitHub {
    owner = "aramg";
    repo = "droidcam";
    rev = "v${version}";
    sha256 = "sha256-Ok8FJweSzmewjYzfBJQ28xGHKK/Y32ng1hOCPVwc8eU=";
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
      --replace "/opt/droidcam-icon.png" "$out/share/icons/hicolor/droidcam.png"
  '';

  preBuild = ''
    makeFlagsArray+=("JPEG=$(pkg-config --libs --cflags libturbojpeg)")
    makeFlagsArray+=("USBMUXD=$(pkg-config --libs --cflags libusbmuxd-2.0)")
  '';

  installPhase = ''
    runHook preInstall

    install -Dt $out/bin droidcam droidcam-cli
    install -D icon2.png $out/share/icons/hicolor/droidcam.png

    runHook postInstall
  '';

  meta = with lib; {
    description = "Linux client for DroidCam app";
    homepage = "https://github.com/aramg/droidcam";
    license = licenses.gpl2Only;
    maintainers = [ maintainers.suhr ];
    platforms = platforms.linux;
  };
}
