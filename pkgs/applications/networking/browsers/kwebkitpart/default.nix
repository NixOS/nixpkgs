{ stdenv, fetchgit, automoc4, cmake, perl, pkgconfig, kdelibs }:

stdenv.mkDerivation rec {
  name = "kwebkitpart-${version}";
  version = "1.3.3";

  src = fetchgit {
    url = git://anongit.kde.org/kwebkitpart;
    rev = "refs/tags/v${version}";
    sha256 = "0kszffgg3zpf319lmzlmdba5gq8kdr5xwb69xwy4s2abc9nvwvbi";
  };

  patches = [ ./CVE-2014-8600.diff ];

  buildInputs = [ kdelibs ];

  nativeBuildInputs = [ automoc4 cmake perl pkgconfig ];

  meta = with stdenv.lib; {
    platforms = platforms.linux;
    maintainers = [ maintainers.phreedom ];
    description = "a WebKit KPart for Konqueror, Akregator and other KDE applications";
    homepage = https://projects.kde.org/projects/extragear/base/kwebkitpart;
  };
}
