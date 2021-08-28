{ mkDerivation
, lib
, fetchFromGitHub
, fetchpatch

, cmake
, pkg-config

, exiv2
, mpv
, opencv4
, qtbase
, qtimageformats
, qtsvg
}:

mkDerivation rec {
  pname = "qimgv";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "easymodo";
    repo = pname;
    rev = "v${version}";
    sha256 = "0b2hddps969gjim2r9a22zaxmnzp600av2zz6icq66ksfrx1rpac";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    exiv2
    mpv
    opencv4
    qtbase
    qtimageformats
    qtsvg
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
    description = "A Qt5 image viewer with optional video support";
    homepage = "https://github.com/easymodo/qimgv";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ cole-h ];
  };
}
