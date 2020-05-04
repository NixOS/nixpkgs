{ mkDerivation
, lib
, fetchFromGitHub
, fetchpatch

, cmake
, pkgconfig

, exiv2
, mpv
, opencv4
, qtbase
, qtimageformats
, qtsvg
}:

mkDerivation rec {
  pname = "qimgv";
  version = "0.9";

  src = fetchFromGitHub {
    owner = "easymodo";
    repo = pname;
    rev = "v${version}";
    sha256 = "1yynjk47gjf2kjfb0ak4blxpb5irgqc1k59z726lwjd6gvg689fl";
  };

  patches = [
    # QtAtomicInt's `storeRelaxed` was introduced in Qt 5.14, while nixpkgs only
    # has Qt 5.12. This appears to be the only instance of Qt 5.12
    # incompatibility, and will be fixed in the next release.
    (fetchpatch {
      url = "https://github.com/easymodo/qimgv/commit/a39d6086ceb9445d2c16943e0719096a99920bf8.patch";
      sha256 = "1z3ngv6i316hrdcdzig4jg6bcdbgfxjaxvm2jcfcw2dnfbfiq47s";
    })
  ];

  nativeBuildInputs = [
    cmake
    pkgconfig
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
