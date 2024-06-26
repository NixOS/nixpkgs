{
  lib,
  stdenv,
  mkDerivation,
  fetchurl,
  qtbase,
  qtmultimedia,
  qtquickcontrols,
  qtimageformats,
  qtxmlpatterns,
  ffmpeg,
  guvcview,
  cmake,
  ninja,
  libxml2,
  gettext,
  pkg-config,
  libgphoto2,
  gphoto2,
  v4l-utils,
  libv4l,
  pcre,
  qwt,
  extra-cmake-modules,
}:

mkDerivation rec {
  pname = "qstopmotion";
  version = "2.5.2";

  src = fetchurl {
    url = "mirror://sourceforge/project/${pname}/Version_${
      builtins.replaceStrings [ "." ] [ "_" ] version
    }/${pname}-${version}-Source.tar.gz";
    sha256 = "sha256-jyBUyadkSuQKXOrr5XZ1jy6of1Qw8S2HPxuOrPc7RnE=";
  };

  buildInputs = [
    qtbase
    qtmultimedia
    qtquickcontrols
    qtimageformats
    qtxmlpatterns
    v4l-utils
    libv4l
    pcre
    guvcview
    qwt
  ];

  nativeBuildInputs = [
    pkg-config
    cmake
    extra-cmake-modules
    ninja
    gettext
    libgphoto2
    gphoto2
    libxml2
    libv4l
  ];

  patchPhase = ''
    substituteInPlace CMakeLists.txt \
      --replace "find_package(Qt5 REQUIRED COMPONENTS Core Widgets Xml" \
                "find_package(Qt5 REQUIRED COMPONENTS Core Widgets Xml Multimedia"
    grep -rl 'qwt' . | xargs sed -i 's@<qwt/qwt_slider.h>@<qwt_slider.h>@g'
  '';

  qtWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath [ ffmpeg ])
  ];

  meta = with lib; {
    homepage = "http://www.qstopmotion.org";
    description = "Create stopmotion animation with a (web)camera";
    longDescription = ''
      Qstopmotion is a tool to create stopmotion
      animation. Its users are able to create stop-motions from pictures
      imported from a camera or from the harddrive and export the
      animation to different video formats such as mpeg or avi.
    '';

    license = lib.licenses.gpl2Plus;
    maintainers = [ maintainers.leenaars ];
    broken = stdenv.isAarch64;
    platforms = lib.platforms.gnu ++ lib.platforms.linux;
    mainProgram = "qstopmotion";
  };
}
