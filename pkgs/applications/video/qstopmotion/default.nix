{ stdenv, fetchurl, qt5, ffmpeg, guvcview, cmake, ninja, libxml2
, gettext, pkgconfig, libgphoto2, gphoto2, v4l-utils, libv4l, pcre
, qwt, extra-cmake-modules }:

stdenv.mkDerivation rec {
  pname = "qstopmotion";
  version = "2.4.1";

  src = fetchurl {
    url = "mirror://sourceforge/project/${pname}/Version_${builtins.replaceStrings ["."] ["_"] version}/${pname}-${version}-Source.tar.gz";
    sha256 = "03r6jxyq0bak2vsy2b78nk27m7fm96hnl8cx11l3l17704j4iglh";
  };

  buildInputs = with qt5; [ v4l-utils libv4l pcre qtbase qtmultimedia ffmpeg guvcview
                            qwt qtquickcontrols qtimageformats qtxmlpatterns ];

  nativeBuildInputs = [ pkgconfig cmake extra-cmake-modules ninja
                        gettext libgphoto2 gphoto2 libxml2 libv4l ];

  patchPhase = ''
    substituteInPlace CMakeLists.txt \
      --replace "find_package(Qt5 REQUIRED COMPONENTS Core Widgets Xml" \
                "find_package(Qt5 REQUIRED COMPONENTS Core Widgets Xml Multimedia"
    grep -rl 'qwt' . | xargs sed -i 's@<qwt/qwt_slider.h>@<qwt_slider.h>@g'
  '';

  meta = with stdenv.lib; {
    homepage = http://www.qstopmotion.org;
    description = "Create stopmotion animation with a (web)camera";
    longDescription = ''
      Qstopmotion is a tool to create stopmotion
      animation. Its users are able to create stop-motions from pictures
      imported from a camera or from the harddrive and export the
      animation to different video formats such as mpeg or avi.
    '';

    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = [ maintainers.leenaars ];
    platforms = stdenv.lib.platforms.gnu ++ stdenv.lib.platforms.linux;
  };
}
