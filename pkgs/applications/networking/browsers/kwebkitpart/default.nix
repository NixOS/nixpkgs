{ stdenv, fetchgit, automoc4, cmake, perl, pkgconfig, kdelibs }:

stdenv.mkDerivation rec {
  name = "kwebkitpart-${version}";
  version = "1.3.3";

  src = fetchgit {
    url = git://anongit.kde.org/kwebkitpart;
    rev = "refs/tags/v${version}";
    sha256 = "13vfv88njml7x67a37ymmlv9qs30fkmvkq0278lp7llmvp5qnxcj";
  };

  patches = [ ./CVE-2014-8600.diff ];

  buildInputs = [ kdelibs ];

  nativeBuildInputs = [ automoc4 cmake perl pkgconfig ];

  meta = with stdenv.lib; {
    platforms = platforms.linux;
    maintainers = [ maintainers.phreedom ];
    description = "A WebKit KPart for Konqueror, Akregator and other KDE applications";
    homepage = https://projects.kde.org/projects/extragear/base/kwebkitpart;
  };
}
