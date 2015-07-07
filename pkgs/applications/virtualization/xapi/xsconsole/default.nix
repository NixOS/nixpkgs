{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "xsconsole-0.9.0";
  version = "0.9.0";

  src = fetchurl {
    url = "https://github.com/jamesbulpin/xsconsole/archive/0.9.0/xsconsole-0.9.0.tar.gz";
    sha256 = "0wx9zb8inbch59mj2hkm58krwr0l6vvlj67xnyp7mxixfra61552";
  };

  patches = [ ./install.patch ];

  configurePhase = "true";

  buildPhase = "true";

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/lib
    make install-base DESTDIR=$out LIBDIR=$out/lib PREFIX=$out
    '';
    # TODO: install python libs properly
    #mkdir -p $out/lib/${python.libPrefix}/site-packages
    #make install-base DESTDIR=$out LIBDIR=$out/lib/${python.libPrefix}/site-packages PREFIX=$out

  meta = {
    homepage = https://github.com/jamesbulpin/xsconsole;
    description = "XenServer Host Configuration Console";
    license = stdenv.lib.licenses.gpl2;
    platforms = [ "i686-linux" "x86_64-linux" ];
    maintainers = with stdenv.lib.maintainers; [ tstrobel ];
  };
}
