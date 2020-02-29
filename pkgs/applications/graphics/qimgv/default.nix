{ mkDerivation, fetchFromGitHub, lib
, pkgconfig, cmake
, exiv2, qtbase, qtimageformats, qtsvg
}:

mkDerivation rec {
  pname = "qimgv";
  version = "0.8.9";

  src = fetchFromGitHub {
    owner = "easymodo";
    repo = pname;
    rev = "v${version}";
    sha256 = "0cmya06j466v0pirhxbzbj1vbz0346y7rbc1gbv4n9xcp6c6bln6";
  };

  cmakeFlags = [
    # Video support appears to be broken; the following gets printed upon
    # attempting to view an mp4, webm, or mkv (and probably all video formats):
    #
    #   [VideoPlayerInitProxy] Error - could not load player library
    #   "qimgv_player_mpv"
    #
    # GIFs are unaffected. If this ever gets addressed, all that is necessary is
    # to add `mpv` to the arguments list and to `buildInputs`, and to remove
    # `cmakeFlags`.
    "-DVIDEO_SUPPORT=OFF"
  ];

  nativeBuildInputs = [
    pkgconfig
    cmake
  ];

  buildInputs = [
    exiv2
    qtbase
    qtimageformats
    qtsvg
  ];

  meta = with lib; {
    description = "Qt5 image viewer with optional video support";
    homepage = "https://github.com/easymodo/qimgv";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ cole-h ];
  };
}
