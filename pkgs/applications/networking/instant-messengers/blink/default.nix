{ stdenv, fetchurl, pythonPackages, pyqt4, cython, libvncserver, zlib, twisted, gnutls }:

pythonPackages.buildPythonPackage rec {
  name = "blink-${version}";
  version = "0.9.1";
  
  src = fetchurl {
    url = "http://download.ag-projects.com/BlinkQt/${name}.tar.gz";
    sha256 = "f578e5186893c3488e7773fbb775028ae54540433a0c51aefa5af983ca2bfdae";
  };

  patches = [ ./pythonpath.patch ];

  propagatedBuildInputs = [ pyqt4 pythonPackages.cjson pythonPackages.sipsimple twisted ];

  buildInputs = [ cython zlib libvncserver ];

  postInstall = ''
    wrapProgram $out/bin/blink \
      --prefix LD_LIBRARY_PATH : ${gnutls}/lib
  '';

  meta = {
    homepage = http://icanblink.com/;
    description = "A state of the art, easy to use SIP client";
  };
}
