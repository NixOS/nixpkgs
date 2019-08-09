{ stdenv, fetchurl, openssl, libsamplerate, alsaLib }:

stdenv.mkDerivation rec {
  name = "pjsip-${version}";
  version = "2.9";

  src = fetchurl {
    url = "https://www.pjsip.org/release/${version}/pjproject-${version}.tar.bz2";
    sha256 = "0dm6l8fypkimmzvld35zyykbg957cm5zb4ny3lchgv68amwfz1fi";
  };

  patches = [ ./fix-aarch64.patch ];

  buildInputs = [ openssl libsamplerate alsaLib ];

  preConfigure = ''
    export LD=$CC
  '';

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
    homepage = https://pjsip.org/;
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = with stdenv.lib.maintainers; [olynch];
    platforms = with stdenv.lib.platforms; linux;
  };
}
