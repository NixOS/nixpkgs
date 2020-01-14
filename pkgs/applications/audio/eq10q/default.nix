{ stdenv, fetchurl, fetchpatch, cmake, fftw, gtkmm2, libxcb, lv2, pkgconfig
, xorg }:
stdenv.mkDerivation rec {
  pname = "eq10q";
  version = "2.2";
  src = fetchurl {
    url = "mirror://sourceforge/project/eq10q/${pname}-${version}.tar.gz";
    sha256 = "16mhcav8gwkp29k9ki4dlkajlcgh1i2wvldabxb046d37dq4qzrk";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ cmake fftw gtkmm2 libxcb lv2 xorg.libpthreadstubs xorg.libXdmcp xorg.libxshmfence ];

  patches = [
    (fetchpatch {
      # glibc 2.27 compatibility
      url = https://sources.debian.org/data/main/e/eq10q/2.2~repack0-2.1/debian/patches/05-pow10.patch;
      sha256 = "07b0wf6k4xqgigv4h095bzfaw8r218wa36r9w1817jcys13r6c5r";
    })
  ];

  installFlags = [ "DESTDIR=$(out)" ];

  fixupPhase = ''
    cp -r $out/var/empty/local/lib $out
    rm -R $out/var
  '';

  meta = {
    description = "LV2 EQ plugins and more, with 64 bit processing";
    longDescription = ''
      Up to 10-Bands parametric equalizer with mono and stereo versions.
      Versatile noise-gate plugin with mono and stereo versions.
      Compressor plugin with mono and stereo versions.
      BassUp plugin - Enhanceing the bass guitar sound or other low frequency sounding instruments.
      Improved high frequency response for peaking filter (in equalizers).
      64 bits floating point internal audio processing.
      Nice GUI with powerful metering for every plugin.
    '';
    homepage = http://eq10q.sourceforge.net/;
    license = stdenv.lib.licenses.gpl3;
    maintainers = [ stdenv.lib.maintainers.magnetophon ];
    platforms = stdenv.lib.platforms.linux;
  };
}
