{ stdenv, fetchgit, cmake, qt5, file, kde5}:

let
  version = "git-2015-07-25";
in
stdenv.mkDerivation rec {
  name = "dfilemanager-${version}";
  src = fetchgit {
    url = "git://git.code.sf.net/p/dfilemanager/code";
    rev = "99afcde199378eb0d499c49a9e28846c22e27483";
    sha256 = "1dd21xl24xvxs100j8nzhpaqfqk8srqs92al9c03jmyjlk31s6lf";
  };

  buildInputs = [ cmake qt5.base qt5.tools qt5.x11extras file kde5.solid];

  cmakeFlags = "-DQT5BUILD=true";

  meta = {
    homepage = "http://dfilemanager.sourceforge.net/";
    description = "File manager written in Qt/C++, it does use one library from kdelibs, the solid lib for easy device handling";
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.eduarrrd ];
  };
}
