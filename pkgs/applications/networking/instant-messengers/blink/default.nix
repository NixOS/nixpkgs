{ stdenv, fetchurl, pythonPackages, pyqt4, cython, libvncserver, zlib, twisted, gnutls }:

pythonPackages.buildPythonPackage rec {
  name = "blink-${version}";
  version = "1.3.0";
  
  src = fetchurl {
    url = "http://download.ag-projects.com/BlinkQt/${name}.tar.gz";
    sha256 = "388a0ca72ad99087cd87b78a4c449f9c079117920bfc50d7843853b8f942d045";
  };

  patches = [ ./pythonpath.patch ];
  postPatch = ''
    sed -i 's|@out@|'"''${out}"'|g' blink/resources.py
  '';

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
