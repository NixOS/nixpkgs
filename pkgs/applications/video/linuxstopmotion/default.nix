{ stdenv, fetchgit, pkgconfig, qt4, SDL, SDL_image, libvorbis, libtar, libxml2
, gamin, qmake4Hook
}:

stdenv.mkDerivation rec {
  version = "0.8";
  name = "linuxstopmotion-${version}";
  
  src = fetchgit {
    url = "git://git.code.sf.net/p/linuxstopmotion/code";
    rev = "refs/tags/${version}";
    sha256 = "1xkkrhllgy2d7k0vrdj794ya7y3g3n7xh8c2qgnb26yrarz79dqj";
  };

  buildInputs = [ pkgconfig qt4 SDL SDL_image libvorbis libtar libxml2 gamin qmake4Hook ];

  patches = [ ./linuxstopmotion-fix-wrong-isProcess-logic.patch ];

  # Installation breaks without this
  preInstall = ''
    mkdir -p "$out/share/stopmotion/translations/"
    cp -v build/*.qm "$out/share/stopmotion/translations/"
  '';

  meta = with stdenv.lib; {
    description = "Create stop-motion animation movies";
    homepage = http://linuxstopmotion.org/;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };
}
