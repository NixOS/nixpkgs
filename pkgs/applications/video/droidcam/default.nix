{ lib, stdenv, fetchFromGitHub
, ffmpeg, libjpeg_turbo, gtk3, alsaLib, speex, libusbmuxd, libappindicator-gtk3
, pkg-config
}:

stdenv.mkDerivation rec {
  pname = "droidcam";
  version = "1.7.2";

  src = fetchFromGitHub {
    owner = "aramg";
    repo = "droidcam";
    rev = "v${version}";
    sha256 = "sha256-Ny/PJu+ifs9hQRDUv1pONBb6fKJzoiNtjPOFc4veU8c=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    ffmpeg
    libjpeg_turbo
    gtk3
    alsaLib
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
