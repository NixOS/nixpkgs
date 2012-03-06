{stdenv, fetchurl, openssl, libsamplerate}:

stdenv.mkDerivation rec {
  name = "pjsip-1.8.10";

  src = fetchurl {
    url = http://www.pjsip.org/release/1.8.10/pjproject-1.8.10.tar.bz2;
    sha256 = "1v2mgbgzn7d3msb406jmg69ms97a0rqg58asykx71dmjipbaiqc0";
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
    license = "GPLv2+";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
