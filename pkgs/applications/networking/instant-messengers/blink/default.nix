{ stdenv, fetchurl, pythonPackages, pyqt4, cython, libvncserver, zlib, twisted, gnutls }:

pythonPackages.buildPythonPackage rec {
  name = "blink-${version}";
  version = "1.2.2";
  
  src = fetchurl {
    url = "http://download.ag-projects.com/BlinkQt/${name}.tar.gz";
    sha256 = "0z7bhfz2775cm7c7s794s5ighp5q7fb6jn8dw025m49vlgqzr78c";
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
