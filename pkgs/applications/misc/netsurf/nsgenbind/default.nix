{ stdenv, fetchurl
, flex, bison
, buildsystem
}:

stdenv.mkDerivation rec {

  name = "netsurf-nsgenbind-${version}";
  version = "0.6";

  src = fetchurl {
    url = "http://download.netsurf-browser.org/libs/releases/nsgenbind-${version}-src.tar.gz";
    sha256 = "0v1cb1rz5fix9ql31nzmglj7sybya6d12b2fkaypm1avcca59xwj";
  };

  buildInputs = [ buildsystem flex bison ];

  makeFlags = [
    "PREFIX=$(out)"
    "NSSHARED=${buildsystem}/share/netsurf-buildsystem"
  ];

  meta = with stdenv.lib; {
    homepage = http://www.netsurf-browser.org/;
    description = "Generator for JavaScript bindings for netsurf browser";
    license = licenses.gpl2;
    maintainers = [ maintainers.vrthra ];
    platforms = platforms.linux;
  };
}
