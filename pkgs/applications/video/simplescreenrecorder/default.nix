{ lib, stdenv, mkDerivation, fetchFromGitHub, alsa-lib, ffmpeg_4, libjack2, libX11, libXext, libXinerama, qtx11extras
, libXfixes, libGLU, libGL, pkg-config, libpulseaudio, libv4l, qtbase, qttools, cmake, ninja
}:

mkDerivation rec {
  pname = "simplescreenrecorder";
  version = "0.4.3";

  src = fetchFromGitHub {
    owner = "MaartenBaert";
    repo = "ssr";
    rev = version;
    sha256 = "0mrx8wprs8bi42fwwvk6rh634ic9jnn0gkfpd6q9pcawnnbz3vq8";
  };

  cmakeFlags = [
    "-DWITH_QT5=TRUE"
    "-DWITH_GLINJECT=${if stdenv.hostPlatform.isx86 then "TRUE" else "FALSE"}"
  ];

  patches = [ ./fix-paths.patch ];

  postPatch = ''
    for i in scripts/ssr-glinject src/AV/Input/GLInjectInput.cpp; do
      substituteInPlace $i \
        --subst-var out \
        --subst-var-by sh ${stdenv.shell}
    done
  '';

  nativeBuildInputs = [ pkg-config cmake ninja ];
  buildInputs = [
    alsa-lib ffmpeg_4 libjack2 libX11 libXext libXfixes libXinerama libGLU libGL
    libpulseaudio libv4l qtbase qttools qtx11extras
  ];

  meta = with lib; {
    description = "A screen recorder for Linux";
    homepage = "https://www.maartenbaert.be/simplescreenrecorder";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.goibhniu ];
  };
}
