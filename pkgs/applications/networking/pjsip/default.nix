{ lib, stdenv, fetchFromGitHub, openssl, libsamplerate, alsa-lib, AppKit, fetchpatch }:

stdenv.mkDerivation rec {
  pname = "pjsip";
  version = "2.12.1";

  src = fetchFromGitHub {
    owner = pname;
    repo = "pjproject";
    rev = version;
    sha256 = "sha256-HIDL4xzzTu3irzrIOf8qSNCAvHGOMpi8EDeqZb8mMnc=";
  };

  patches = [
    ./fix-aarch64.patch
    (fetchpatch {
      name = "CVE-2022-39269.patch";
      url = "https://github.com/pjsip/pjproject/commit/d2acb9af4e27b5ba75d658690406cec9c274c5cc.patch";
      sha256 = "sha256-bKE/MrRAqN1FqD2ubhxIOOf5MgvZluHHeVXPjbR12iQ=";
    })
    (fetchpatch {
      name = "CVE-2022-39244.patch";
      url = "https://github.com/pjsip/pjproject/commit/c4d34984ec92b3d5252a7d5cddd85a1d3a8001ae.patch";
      sha256 = "sha256-hTUMh6bYAizn6GF+sRV1vjKVxSf9pnI+eQdPOqsdJI4=";
    })
  ];

  buildInputs = [ openssl libsamplerate ]
    ++ lib.optional stdenv.isLinux alsa-lib
    ++ lib.optional stdenv.isDarwin AppKit;

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

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "A multimedia communication library written in C, implementing standard based protocols such as SIP, SDP, RTP, STUN, TURN, and ICE";
    homepage = "https://pjsip.org/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ olynch ];
    mainProgram = "pjsua";
    platforms = platforms.linux ++ platforms.darwin;
  };
}
