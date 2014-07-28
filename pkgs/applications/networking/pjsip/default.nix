{stdenv, fetchurl, openssl, libsamplerate}:

stdenv.mkDerivation rec {
  name = "pjsip-2.1";

  src = fetchurl {
    url = http://www.pjsip.org/release/2.1/pjproject-2.1.tar.bz2;
    md5 = "310eb63638dac93095f6a1fc8ee1f578";
  };

  buildInputs = [ openssl libsamplerate ];

  postInstall = ''
    mkdir -p $out/bin
    cp pjsip-apps/bin/pjsua-* $out/bin/pjsua
    mkdir -p $out/share/${name}/samples
    cp pjsip-apps/bin/samples/*/* $out/share/${name}/samples
  '';

  # We need the libgcc_s.so.1 loadable (for pthread_cancel to work)
  dontPatchELF = true;

  meta = {
    description = "SIP stack and media stack for presence, im, and multimedia communication";
    homepage = http://pjsip.org/;
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
