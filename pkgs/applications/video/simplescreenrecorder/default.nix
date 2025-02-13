{
  lib,
  stdenv,
  mkDerivation,
  fetchFromGitHub,
  alsa-lib,
  ffmpeg,
  libjack2,
  libX11,
  libXext,
  libXinerama,
  qtx11extras,
  libXfixes,
  libGLU,
  libGL,
  pkg-config,
  libpulseaudio,
  libv4l,
  qtbase,
  qttools,
  cmake,
  ninja,
  nix-update-script,
}:

mkDerivation rec {
  pname = "simplescreenrecorder";
  version = "0.4.4-unstable-2024-08-13";

  src = fetchFromGitHub {
    owner = "MaartenBaert";
    repo = "ssr";
    rev = "4e3ba13dd212fc4213fe0911f371bc7d34033b8d";
    hash = "sha256-jBZkyrZOrUljWgO8U4SZOTCu3sOm83unQ7vyv+KkAuE=";
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

  nativeBuildInputs = [
    pkg-config
    cmake
    ninja
  ];
  buildInputs = [
    alsa-lib
    ffmpeg
    libjack2
    libX11
    libXext
    libXfixes
    libXinerama
    libGLU
    libGL
    libpulseaudio
    libv4l
    qtbase
    qttools
    qtx11extras
  ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Screen recorder for Linux";
    homepage = "https://www.maartenbaert.be/simplescreenrecorder";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = [ ];
  };
}
