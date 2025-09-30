{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  libsForQt5,
  exiv2,
  mpv,
  opencv4,
}:

stdenv.mkDerivation rec {
  pname = "qimgv";
  version = "1.0.3-unstable-2024-10-11";

  src = fetchFromGitHub {
    owner = "easymodo";
    repo = "qimgv";
    rev = "a4d475fae07847be7c106cb628fb97dad51ab920";
    sha256 = "sha256-iURUJiPe8hbCnpaf6lk8OVSzVqrJKGab889yOic5yLI=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    libsForQt5.wrapQtAppsHook
  ];

  cmakeFlags = [
    "-DVIDEO_SUPPORT=ON"
  ];

  buildInputs = [
    exiv2
    mpv
    opencv4.cxxdev
    libsForQt5.qtbase
    libsForQt5.qtimageformats
    libsForQt5.qtsvg
    libsForQt5.qttools
  ];

  postPatch = ''
    sed -i "s@/usr/bin/mpv@${mpv}/bin/mpv@" \
      qimgv/settings.cpp
  '';

  # Wrap the library path so it can see `libqimgv_player_mpv.so`, which is used
  # to play video files within qimgv itself.
  qtWrapperArgs = [
    "--prefix LD_LIBRARY_PATH : ${placeholder "out"}/lib"
  ];

  meta = with lib; {
    description = "Qt5 image viewer with optional video support";
    mainProgram = "qimgv";
    homepage = "https://github.com/easymodo/qimgv";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ cole-h ];
  };
}
