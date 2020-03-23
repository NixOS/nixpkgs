{ stdenv, fetchFromGitHub, openssl, libsamplerate, alsaLib }:

stdenv.mkDerivation rec {
  pname = "pjsip";
  version = "2.10";

  src = fetchFromGitHub {
    owner = pname;
    repo = "pjproject";
    rev = version;
    sha256 = "1aklicpgwc88578k03i5d5cm5h8mfm7hmx8vfprchbmaa2p8f4z0";
  };

  patches = [ ./fix-aarch64.patch ];

  buildInputs = [ openssl libsamplerate alsaLib ];

  preConfigure = ''
    export LD=$CC
  '';

  postInstall = ''
    mkdir -p $out/bin
    cp pjsip-apps/bin/pjsua-* $out/bin/pjsua
    mkdir -p $out/share/${pname}-${version}/samples
    cp pjsip-apps/bin/samples/*/* $out/share/${pname}-${version}/samples
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
