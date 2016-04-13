{ stdenv, fetchzip, perl, python, gnuplot, coreutils, gnugrep }:

stdenv.mkDerivation rec {
  name = "gitstats-${version}";
  version = "2016-01-08";

  # upstream does not make releases
  src = fetchzip {
    url = "https://github.com/hoxu/gitstats/archive/55c5c285558c410bb35ebf421245d320ab9ee9fa.zip";
    sha256 = "1bfcwhksylrpm88vyp33qjby4js31zcxy7w368dzjv4il3fh2i59";
    name = name + "-src";
  };

  buildInputs = [ perl python ];

  postPatch = ''
    sed -e "s|gnuplot_cmd = .*|gnuplot_cmd = '${gnuplot}/bin/gnuplot'|" \
        -e "s|\<wc\>|${coreutils}/bin/wc|g" \
        -e "s|\<grep\>|${gnugrep}/bin/grep|g" \
        -i gitstats
  '';

  buildPhase = ''
    make man VERSION="${version}"
  '';

  installPhase = ''
    make install PREFIX="$out" VERSION="${version}"
    install -Dm644 doc/gitstats.1 "$out"/share/man/man1/gitstats.1
  '';

  meta = with stdenv.lib; {
    homepage = http://gitstats.sourceforge.net/;
    description = "Git history statistics generator";
    license = licenses.gpl2Plus;
    platforms = platforms.all;
    maintainers = [ maintainers.bjornfor ];
  };
}
