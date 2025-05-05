{
  lib,
  stdenv,
  fetchurl,

  # nativeBuildInputs
  cmake,
  extra-cmake-modules,
  gettext,
  gphoto2,
  libgphoto2,
  libsForQt5,
  libv4l,
  libxml2,
  ninja,
  pkg-config,

  # buildInputs
  guvcview,
  pcre,
  v4l-utils,

  ffmpeg,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "qstopmotion";
  version = "2.5.2";

  src = fetchurl {
    url = "mirror://sourceforge/project/qstopmotion/Version_${
      lib.replaceStrings [ "." ] [ "_" ] finalAttrs.version
    }/qstopmotion-${finalAttrs.version}-Source.tar.gz";
    hash = "sha256-jyBUyadkSuQKXOrr5XZ1jy6of1Qw8S2HPxuOrPc7RnE=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    gettext
    gphoto2
    libgphoto2
    libsForQt5.wrapQtAppsHook
    libv4l
    libxml2
    ninja
    pkg-config
  ];

  buildInputs = [
    (guvcview.override {
      useQt = true;
      useGtk = false;
    })
    libsForQt5.qtbase
    libsForQt5.qtimageformats
    libsForQt5.qtmultimedia
    libsForQt5.qtquickcontrols
    libsForQt5.qtxmlpatterns
    libsForQt5.qwt
    libv4l
    pcre
    v4l-utils
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail \
        "find_package(Qt5 REQUIRED COMPONENTS Core Widgets Xml" \
        "find_package(Qt5 REQUIRED COMPONENTS Core Widgets Xml Multimedia"
    grep -rl 'qwt' . | xargs sed -i 's@<qwt/qwt_slider.h>@<qwt_slider.h>@g'
  '';

  qtWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath [ ffmpeg ])
  ];

  meta = {
    homepage = "http://www.qstopmotion.org";
    description = "Create stopmotion animation with a (web)camera";
    longDescription = ''
      Qstopmotion is a tool to create stopmotion
      animation. Its users are able to create stop-motions from pictures
      imported from a camera or from the harddrive and export the
      animation to different video formats such as mpeg or avi.
    '';
    license = lib.licenses.gpl2Plus;
    maintainers = [ lib.maintainers.leenaars ];
    platforms = lib.platforms.gnu ++ lib.platforms.linux;
    mainProgram = "qstopmotion";
  };
})
