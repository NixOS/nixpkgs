{ stdenv, fetchgit, kdelibs }:

stdenv.mkDerivation rec {
  name = "kwebkitpart-1.3.2";

  src = fetchgit {
    url = git://anongit.kde.org/kwebkitpart;
    rev = "292f32fda933b2ead5a61ff1ec457f839fad5c85";
    sha256 = "1b2jar9b1yb3gy9fnq8dn2n4z8lffb6pfrj9jc4rjzv5b3rwh1ak";
  };

  buildInputs = [ kdelibs ];

  meta = with stdenv.lib; {
    platforms = platforms.linux;
    maintainers = [ maintainers.phreedom ];
    description = "a WebKit KPart for Konqueror, Akregator and other KDE applications";
    homepage = https://projects.kde.org/projects/extragear/base/kwebkitpart;
  };
}
