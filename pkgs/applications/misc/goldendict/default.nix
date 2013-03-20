{ stdenv, fetchurl, pkgconfig, qt4, libXtst, libvorbis, phonon, hunspell }:
stdenv.mkDerivation rec {
  name = "goldendict-1.0.1";
  src = fetchurl {
    url = "mirror://sourceforge/goldendict/${name}-src.tar.bz2";
    sha256 = "19p99dd5jgs0k66sy30vck7ymqj6dv1lh6w8xw18zczdll2h9yxk";
  };
  buildInputs = [ pkgconfig qt4 libXtst libvorbis phonon hunspell ];
  unpackPhase = ''
    mkdir ${name}-src
    cd ${name}-src
    tar xf ${src}
  '';
  patches = [ ./goldendict-paths.diff ./gcc47.patch ];
  patchFlags = "-p 0";
  configurePhase = ''
    qmake
  '';
  installPhase = ''
    make INSTALL_ROOT="$out" install
    rm -rf "$out/share/app-install"
  '';

  meta = {
    homepage = http://goldendict.org/;
    description = "a feature-rich dictionary lookup program";

    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.astsmtl ];
  };
}
