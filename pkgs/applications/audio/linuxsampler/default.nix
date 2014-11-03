{ stdenv, fetchsvn, alsaLib, asio, autoconf, automake, bison
, jack2, libgig, libsndfile, libtool, lv2, pkgconfig }:

stdenv.mkDerivation rec {
  name = "linuxsampler-svn-${version}";
  version = "2340";

  src = fetchsvn {
    url = "https://svn.linuxsampler.org/svn/linuxsampler/trunk";
    rev = "${version}";
    sha256 = "0zsrvs9dwwhjx733m45vfi11yjkqv33z8qxn2i9qriq5zs1f0kd7";
  };

  patches = ./linuxsampler_lv2_sfz_fix.diff;

  # It fails to compile without this option. I'm not sure what the bug
  # is, but everything works OK for me (goibhniu).
  configureFlags = [ "--disable-nptl-bug-check" ];

  preConfigure = ''
    sed -e 's/which/type -P/g' -i scripts/generate_parser.sh
    make -f Makefile.cvs
  '';

  buildInputs = [ 
   alsaLib asio autoconf automake bison jack2 libgig libsndfile
   libtool lv2 pkgconfig
  ];

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
