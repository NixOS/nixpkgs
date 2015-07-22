{ stdenv, fetchgit, cmake, pkgconfig, libusb }:

stdenv.mkDerivation rec {
  name = "hackrf-${version}";
  version = "2014.08.1";

  src = fetchgit {
    url = "git://github.com/mossmann/hackrf";
    rev = "refs/tags/v${version}";
    sha256 = "1f3mmzyn6qqbl02h6dkz0zybppihqgpdxjgqmkb1pn3i0d98ydb3";
  };

  buildInputs = [
    cmake pkgconfig libusb
  ];
  
  preConfigure = ''
    cd host  
  '';
  
  meta = with stdenv.lib; {
    description = "An open source SDR platform";
    homepage = http://greatscottgadgets.com/hackrf/;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.sjmackenzie ];
  };
}
