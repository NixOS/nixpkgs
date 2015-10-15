{ stdenv, fetchurl, pythonPackages, pyqt4, cython, libvncserver, zlib, twisted
, gnutls, libvpx }:

pythonPackages.buildPythonPackage rec {
  name = "blink-${version}";
  version = "1.4.1";
  
  src = fetchurl {
    url = "http://download.ag-projects.com/BlinkQt/${name}.tar.gz";
    sha256 = "0lpc3gm0hk55m7i2hlmk2p76akcfvnqxg0hyamfhha90nv6fk7sf";
  };

  patches = [ ./pythonpath.patch ];
  postPatch = ''
    sed -i 's|@out@|'"''${out}"'|g' blink/resources.py
  '';

  propagatedBuildInputs = with pythonPackages;[ pyqt4 cjson sipsimple twisted
    ];

  buildInputs = [ cython zlib libvncserver libvpx ];

  postInstall = ''
    wrapProgram $out/bin/blink \
      --prefix LD_LIBRARY_PATH ":" ${gnutls.out}/lib
  '';

  meta = with stdenv.lib; {
    homepage = http://icanblink.com/;
    description = "A state of the art, easy to use SIP client";
    platforms = platforms.linux;
    license = licenses.mit;
    maintainers = with maintainers; [ pSub ];
  };
}
