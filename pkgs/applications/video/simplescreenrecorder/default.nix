{ lib, stdenv, mkDerivation, fetchFromGitHub, alsa-lib, ffmpeg_4, libjack2, libX11, libXext, libXinerama, qtx11extras
, libXfixes, libGLU, libGL, pkg-config, libpulseaudio, libv4l, qtbase, qttools, cmake, ninja, nix-update-script
}:

mkDerivation rec {
  pname = "simplescreenrecorder";
  version = "0.4.4";

  src = fetchFromGitHub {
    owner = "MaartenBaert";
    repo = "ssr";
    rev = version;
    sha256 = "sha256-cVjQmyk+rCqmDJzdnDk7bQ8kpyD3HtTw3wLVx2thHok=";
  };

  cmakeFlags = [
    "-DWITH_QT5=TRUE"
    "-DWITH_GLINJECT=${if stdenv.hostPlatform.isx86 then "TRUE" else "FALSE"}"
  ];

  postPatch = ''
    substituteInPlace scripts/ssr-glinject \
      --replace-fail "libssr-glinject.so" "$out/lib/libssr-glinject.so"

    substituteInPlace src/AV/Input/GLInjectInput.cpp \
      --replace-fail "/bin/sh" "${stdenv.shell}" \
      --replace-fail "libssr-glinject.so" "$out/lib/libssr-glinject.so"
  '';

  nativeBuildInputs = [ pkg-config cmake ninja ];
  buildInputs = [
    alsa-lib ffmpeg_4 libjack2 libX11 libXext libXfixes libXinerama libGLU libGL
    libpulseaudio libv4l qtbase qttools qtx11extras
  ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "A screen recorder for Linux";
    homepage = "https://www.maartenbaert.be/simplescreenrecorder";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.goibhniu ];
  };
}
