{ lib
, stdenv
, fetchFromGitHub
, openssl
, libsamplerate
, alsa-lib
, AppKit
, fetchpatch
}:

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

  postPatch = ''
    # disable some tests that won't work in nix's build environment
    # (but have been checked to work outside it). not all parts of the
    # tests have simple ways to skip

    sed -i \
      -e '/^static int perform_test(/{:x; n; s@{@{ if(strstr(title,"srflx")) { PJ_LOG(3,(THIS_FILE, INDENT "SKIP")); return 0;}@; Tx;}' \
      -e '/Iterate each test item/{:y; n; s@{@{ if(strstr(sess_cfg[i].title,"all candidates")||strstr(sess_cfg[i].title,"srflx")) { PJ_LOG(3,(THIS_FILE, INDENT "SKIP")); continue;}@; Ty;}' \
      -e '/^static int perform_trickle_test(/{:z; n; s@{@{ if(strstr(title,"host+turn")) { PJ_LOG(3,(THIS_FILE, INDENT "SKIP")); return 0;}@; Tz;}' \
      pjnath/src/pjnath-test/ice_test.c
    sed -i \
      -e '/^#define INCLUDE_CONCUR_TEST/c#define INCLUDE_CONCUR_TEST 0' \
      pjnath/src/pjnath-test/test.h
    sed -i \
      -e '/^#define INCLUDE_TCP_TEST/c#define INCLUDE_TCP_TEST 0' \
      -e '/^#define INCLUDE_TSX_DESTROY_TEST/c#define INCLUDE_TSX_DESTROY_TEST 0' \
      pjsip/src/test/test.h
  '';

  buildInputs = [ openssl libsamplerate ]
    ++ lib.optional stdenv.isLinux alsa-lib
    ++ lib.optional stdenv.isDarwin AppKit;

  preConfigure = ''
    export LD=$CC
  '';

  doCheck = true;
  checkTarget = [
    "pjlib-test"
    "pjlib-util-test"
    "pjnath-test"
    "pjmedia-test"
    "pjsip-test"
  ];
  enableParallelChecking = true;

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
