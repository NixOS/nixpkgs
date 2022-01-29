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
, wrapQtAppsHook
, qtwayland
, qt5compat
, qtimageformats
, qtsvg
}:

mkDerivation rec {
  pname = "qimgv";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "easymodo";
    repo = pname;
    rev = "v${version}";
    sha256 = "YlV/ysm7bdPverpKpanrL+jPVvMtP1paoAm0PREMaww=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    wrapQtAppsHook
  ];

  propagatedBuildInputs = [
    exiv2
    mpv
    opencv4
    qtbase
    qtwayland
    qt5compat
    qtimageformats
    qtsvg
  ];

  # FIXME only needed for qt6
  # set attributes for qt-6/hooks/qmake-hook.sh
  # TODO better. we do not want to set this for every libsForQt6.callPackage target
  inherit (qtbase) qtDocPrefix qtQmlPrefix qtPluginPrefix;

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
    description = "A Qt image viewer with optional video support";
    homepage = "https://github.com/easymodo/qimgv";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ cole-h ];
  };
}
