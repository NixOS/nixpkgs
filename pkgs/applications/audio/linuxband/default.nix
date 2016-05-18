{ stdenv, fetchurl, makeWrapper, pkgconfig, MMA, libjack2, libsmf, python, pyGtkGlade, pygtksourceview }:

stdenv.mkDerivation rec {
  version = "12.02.1";
  name = "linuxband-${version}";

  src = fetchurl {
    url = "http://linuxband.org/assets/sources/${name}.tar.gz";
    sha256 = "1r71h4yg775m4gax4irrvygmrsclgn503ykmc2qwjsxa42ri4n2n";
  };

  buildInputs = [ makeWrapper pkgconfig MMA libjack2 libsmf python pyGtkGlade pygtksourceview ];

  patchPhase = ''
    sed -i 's@/usr/@${MMA}/@g' src/main/config/linuxband.rc.in
    cat src/main/config/linuxband.rc.in
  '';

  postFixup = ''
    PYTHONPATH=$pyGtkGlade/share/:pygtksourceview/share/:$PYTHONPATH
    for f in $out/bin/*; do
      wrapProgram $f \
      --prefix PYTHONPATH : $PYTHONPATH
    done
  '';

  meta = {
    description = "A GUI front-end for MMA: Type in the chords, choose the groove and it will play an accompaniment";
    homepage = http://linuxband.org/;
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.magnetophon ];
    platforms = stdenv.lib.platforms.linux;
  };
}
