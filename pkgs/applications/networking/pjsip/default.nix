{ stdenv, fetchurl, openssl, libsamplerate, alsaLib }:

stdenv.mkDerivation rec {
  name = "pjsip-${version}";
  version = "2.6";

  src = fetchurl {
    url = "http://www.pjsip.org/release/${version}/pjproject-${version}.tar.bz2";
    sha256 = "1d67c58jn22f7h6smkykk5vwl3sqpc7xi2vm3j3lbn3lq6hisnig";
  };

  buildInputs = [ openssl libsamplerate alsaLib ];

  postInstall = ''
    mkdir -p $out/bin
    cp pjsip-apps/bin/pjsua-* $out/bin/pjsua
    mkdir -p $out/share/${name}/samples
    cp pjsip-apps/bin/samples/*/* $out/share/${name}/samples
  '';

  # We need the libgcc_s.so.1 loadable (for pthread_cancel to work)
  dontPatchELF = true;

  meta = {
    description = "A multimedia communication library written in C, implementing standard based protocols such as SIP, SDP, RTP, STUN, TURN, and ICE";
    homepage = http://pjsip.org/;
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
