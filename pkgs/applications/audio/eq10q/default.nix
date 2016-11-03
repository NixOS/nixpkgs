{ stdenv, fetchurl, cmake, fftw, gtkmm2, libxcb, lv2, pkgconfig, xorg }:
stdenv.mkDerivation rec {
  name = "eq10q-${version}";
  version = "2.1";
  src = fetchurl {
    url = "mirror://sourceforge/project/eq10q/${name}.tar.gz";
    sha256 = "0brrr6ydsppi4zzn3vcgl0zgq5r8jmlcap1hpr3k43yvlwggb880";
  };

  buildInputs = [ cmake fftw gtkmm2 libxcb lv2 pkgconfig xorg.libpthreadstubs xorg.libXdmcp xorg.libxshmfence ];

  installFlags = ''
    DESTDIR=$(out)
  '';

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
