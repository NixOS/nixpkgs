{ stdenv, fetchsvn, alsaLib, asio, autoconf, automake, bison
, jackaudio, libgig, libsndfile, libtool , pkgconfig }:

stdenv.mkDerivation rec {
  name = "linuxsampler-svn-${version}";
  version = "2340";

  src = fetchsvn {
    url = "https://svn.linuxsampler.org/svn/linuxsampler/trunk";
    rev = "${version}";
    sha256 = "0zsrvs9dwwhjx733m45vfi11yjkqv33z8qxn2i9qriq5zs1f0kd7";
  };

  patchPhase = "sed -e 's/which/type -P/g' -i scripts/generate_parser.sh";

  preConfigure = "make -f Makefile.cvs";

  buildInputs = [ 
   alsaLib asio autoconf automake bison jackaudio libgig libsndfile
   libtool pkgconfig 
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
    license = licenses.gpl2;
    maintainers = [ maintainers.goibhniu ];
  };
}
