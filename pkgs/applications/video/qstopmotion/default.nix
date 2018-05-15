{ stdenv, fetchurl, qt5, ffmpeg, guvcview, automoc4
, cmake, ninja, libxml2, gettext, pkgconfig, libgphoto2, gphoto2, v4l_utils
, libv4l, pcre }:

stdenv.mkDerivation rec {
  pname = "qstopmotion";
  version = "2.3.2";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/project/${pname}/Version_2_3_2/${name}-Source.tar.gz";
    sha256 = "1vbiznwyc05jqg0dpmgxmvf7kdzmlck0i8v2c5d69kgrdnaypcrf";
  };

  buildInputs = [ qt5.qtbase ffmpeg guvcview v4l_utils libv4l pcre ];

  nativeBuildInputs = [ pkgconfig cmake ninja gettext libgphoto2 gphoto2 libxml2 libv4l ];

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
