{stdenv, fetchurl, xcp-python-libs, python, setuptools}:

stdenv.mkDerivation {
  name = "linux-guest-loader-1.9.0";
  version = "1.9.0";

  src = fetchurl {
    url = "https://github.com/xenserver/linux-guest-loader/archive/v1.9.0/linux-guest-loader-1.9.0.tar.gz";
    sha256 = "15n521p56r6dv3q99hlpx90qjnppj6hk2kccpnrbs3cmyy0a2y7g";
  };

  buildInputs = [ xcp-python-libs python setuptools ];

  configurePhase = "true";

  buildPhase = ''
    python setup.py build
    '';


  installPhase = ''
    python setup.py install -O1 --skip-build --prefix $out
    #TODO: proplery wrap python script
    mv $out/bin/eliloader.py $out/bin/eliloader
    rm -rf $out/lib/${python.libPrefix}/site-packages/*-py*.egg-info
    '';

  meta = {
    homepage = https://github.com/xenserver/linux-guest-loader;
    description = "Bootloader for EL-based distributions that support Xen";
    license = stdenv.lib.licenses.gpl2;
    platforms = [ "i686-linux" "x86_64-linux" ];
    maintainers = with stdenv.lib.maintainers; [ tstrobel ];
  };
}
