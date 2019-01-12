{ stdenv, fetchurl, oraclejre, gnutar }:

stdenv.mkDerivation {
  name = "mediathekview-13.2.1";
  src = fetchurl {
    url = "https://github.com/mediathekview/MediathekView/releases/download/13.2.1/MediathekView-13.2.1.tar.gz";
    sha256 = "11wg6klviig0h7pprfaygamsgqr7drqra2s4yxgfak6665033l2a";
  };
  unpackPhase = "true";

  buildInputs = [ gnutar ];
  
  # Could use some more love
  # Maybe we can also preconfigure locations for vlc and the others.
  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/opt/mediathekview
    cd $out/opt/mediathekview
    tar xf $src --strip 1
    find . -iname '*.exe' -delete
    sed -i -e 's, java, ${oraclejre}/bin/java,' MediathekView.sh
    ln -s $out/opt/mediathekview/MediathekView.sh $out/bin/mediathekview
  '';

  meta = with stdenv.lib; {
    homepage = http://zdfmediathk.sourceforge.net/;
    license = stdenv.lib.licenses.gpl3;
    maintainers = [ maintainers.chaoflow ];
    platforms = platforms.linux;  #  also macOS and cygwin, but not investigated, yet
  };
}
