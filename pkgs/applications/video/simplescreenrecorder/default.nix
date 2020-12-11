{ stdenv, mkDerivation, fetchurl, alsaLib, ffmpeg_3, libjack2, libX11, libXext, libXinerama, qtx11extras
, libXfixes, libGLU, libGL, pkgconfig, libpulseaudio, qtbase, cmake, ninja, fetchFromGitHub
}:

mkDerivation rec {
  pname = "simplescreenrecorder";
  version = "0.4.2";

  src = fetchFromGitHub {
    name = "simplescreenrecorder";
    owner = "MaartenBaert";
    repo = "ssr";
    rev = "ed69cf51dfa5d17179244badb0f2652574219554";
    sha256 = "1dzp5yzqlha65crzklx2qlan6ssw1diwzfpc4svd7gnr858q2292";
  };

  cmakeFlags = [ "-DWITH_QT5=TRUE" ];

  patches = [ ./fix-paths.patch ];

  postPatch = ''
    for i in scripts/ssr-glinject src/AV/Input/GLInjectInput.cpp; do
      substituteInPlace $i \
        --subst-var out \
        --subst-var-by sh ${stdenv.shell}
    done
  '';

  nativeBuildInputs = [ pkgconfig cmake ninja ];
  buildInputs = [
    alsaLib ffmpeg_3 libjack2 libX11 libXext libXinerama libXfixes libGLU
    libGL libpulseaudio qtbase qtx11extras
  ];

  meta = with stdenv.lib; {
    description = "A screen recorder for Linux";
    homepage = "https://www.maartenbaert.be/simplescreenrecorder";
    license = licenses.gpl3;
    platforms = [ "x86_64-linux" ];
    maintainers = [ maintainers.goibhniu ];
  };
}
