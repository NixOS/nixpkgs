{ stdenv, fetchurl, autoconf, automake, bison, libtool, pkgconfig, which
, alsaLib, asio, libjack2, libgig, libsndfile, lv2 }:

stdenv.mkDerivation rec {
  name = "linuxsampler-${version}";
  version = "2.1.0";

  src = fetchurl {
    url = "https://download.linuxsampler.org/packages/${name}.tar.bz2";
    sha256 = "0fdxpw7jjfi058l95131d6d8538h05z7n94l60i6mhp9xbplj2jf";
  };

  preConfigure = ''
    make -f Makefile.svn
  '';

  nativeBuildInputs = [ autoconf automake bison libtool pkgconfig which ];

  buildInputs = [ alsaLib asio libjack2 libgig libsndfile lv2 ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = http://www.linuxsampler.org;
    description = "Sampler backend";
    longDescription = ''
      Includes sampler engine, audio and MIDI drivers, network layer
      (LSCP) API and native C++ API.

      LinuxSampler is licensed under the GNU GPL with the exception
      that USAGE of the source code, libraries and applications FOR
      COMMERCIAL HARDWARE OR SOFTWARE PRODUCTS IS NOT ALLOWED without
      prior written permission by the LinuxSampler authors. If you
      have questions on the subject, that are not yet covered by the
      FAQ, please contact us.
    '';
    license = licenses.unfree;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.linux;
  };
}
