{ lib, stdenv, fetchFromGitHub, openssl, libsamplerate, alsa-lib, AppKit }:

stdenv.mkDerivation rec {
  pname = "pjsip";
  version = "2.10";

  src = fetchFromGitHub {
    owner = pname;
    repo = "pjproject";
    rev = version;
    sha256 = "1aklicpgwc88578k03i5d5cm5h8mfm7hmx8vfprchbmaa2p8f4z0";
  };

  patches = [
    ./fix-aarch64.patch
  ];

  buildInputs = [ openssl libsamplerate ]
    ++ lib.optional stdenv.isLinux alsa-lib
    ++ lib.optional stdenv.isDarwin AppKit;

  preConfigure = ''
    export LD=$CC
  '' # Fixed on master, remove with 2.11
     + lib.optionalString stdenv.isDarwin ''
    NIX_CFLAGS_COMPILE+=" -framework Security"
  '';

  postInstall = ''
    mkdir -p $out/bin
    cp pjsip-apps/bin/pjsua-* $out/bin/pjsua
    mkdir -p $out/share/${pname}-${version}/samples
    cp pjsip-apps/bin/samples/*/* $out/share/${pname}-${version}/samples
  '';

  # We need the libgcc_s.so.1 loadable (for pthread_cancel to work)
  dontPatchELF = true;

  meta = with lib; {
    description = "A multimedia communication library written in C, implementing standard based protocols such as SIP, SDP, RTP, STUN, TURN, and ICE";
    homepage = "https://pjsip.org/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ olynch ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
