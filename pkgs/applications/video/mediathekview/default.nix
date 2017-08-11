{ stdenv, fetchurl, jre, unzip }:

stdenv.mkDerivation {
  name = "mediathekview-9";
  src = fetchurl {
    url = "mirror://sourceforge/zdfmediathk/MediathekView_9.zip";
    sha256 = "1wff0igr33z9p1mjw7yvb6658smdwnp22dv8klz0y8qg116wx7a4";
  };
  unpackPhase = "true";

  buildInputs = [ unzip ];
  
  # Could use some more love
  # Maybe we can also preconfigure locations for vlc and the others.
  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/opt/mediathekview
    cd $out/opt/mediathekview
    unzip $src
    find . -iname '*.exe' -delete
    sed -i -e 's, java, ${jre}/bin/java,' MediathekView__Linux.sh
    ln -s $out/opt/mediathekview/MediathekView__Linux.sh $out/bin/mediathekview
  '';

  meta = with stdenv.lib; {
    homepage = http://zdfmediathk.sourceforge.net/;
    license = stdenv.lib.licenses.gpl3;
    maintainers = [ maintainers.chaoflow ];
    platforms = platforms.linux;  #  also macOS and cygwin, but not investigated, yet
  };
}
