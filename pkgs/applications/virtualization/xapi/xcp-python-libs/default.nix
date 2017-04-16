{stdenv, fetchurl, python, setuptools}:

stdenv.mkDerivation {
  name = "xcp-python-libs-1.9.0";
  version = "1.9.0";

  src = fetchurl {
    url = "https://github.com/xenserver/python-libs/archive/v1.9.0/xcp-python-libs-1.9.0.tar.gz";
    sha256 = "1a2xzgb6abmk45m2h9vya49jg4njzr03wsqrwlhvnhg1g4lrffcq";
  };

  buildInputs = [ python setuptools ];

  configurePhase = "true";

  buildPhase = ''
    mkdir -p xcp
    cp *.py xcp
    cp -r net xcp
    python setup.py build
    '';


  installPhase = ''
    python setup.py install -O2 --skip-build --prefix $out
    rm -rf $out/lib/${python.libPrefix}/site-packages/*-py*.egg-info
    '';

  meta = {
    homepage = https://github.com/xenserver/python-libs;
    description = "Common XenServer Python classes";
    license = stdenv.lib.licenses.gpl2;
    platforms = [ "i686-linux" "x86_64-linux" ];
    maintainers = with stdenv.lib.maintainers; [ tstrobel ];
  };
}
