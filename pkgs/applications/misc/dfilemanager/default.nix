{ stdenv, fetchgit, cmake, qt5, file, kde5}:

let
  version = "git-2015-06-10";
in
stdenv.mkDerivation rec {
  name = "dfilemanager-${version}";
  src = fetchgit {
    url = "git://git.code.sf.net/p/dfilemanager/code";
    rev = "806a28aa8fed30941a2fd6784c7c9c240bca30e3";
    sha256 = "1k15qzjmqg9ffv4cl809b071dpyckf8jspkhfhpbmfd9wasr0m7i";
  };

  buildInputs = [ cmake qt5.base qt5.tools qt5.x11extras file kde5.solid];

  cmakeFlags = "-DQT5BUILD=true";

  meta = {
    homepage = "http://dfilemanager.sourceforge.net/";
    description = "File manager written in Qt/C++, it does use one library from kdelibs, the solid lib for easy device handling";
    #license = stdenv.lib.licenses; # license not specified
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.eduarrrd ];
  };
}
