{ stdenv, fetchgit, cmake, file, qtbase, qttools, qtx11extras, solid }:

let
  version = "git-2016-01-10";
in
stdenv.mkDerivation {
  name = "dfilemanager-${version}";
  src = fetchgit {
    url = "git://git.code.sf.net/p/dfilemanager/code";
    rev = "2c5078b05e0ad74c037366be1ab3e6a03492bde4";
    sha256 = "1qwhnlcc2j8sr1f3v63sxs3m7q7w1xy6c2jqsnznjgm23b5h3hxd";
  };

  buildInputs = [ cmake qtbase qttools file solid ];

  cmakeFlags = "-DQT5BUILD=true";

  meta = {
    homepage = "http://dfilemanager.sourceforge.net/";
    description = "File manager written in Qt/C++";
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.eduarrrd ];
  };
}
