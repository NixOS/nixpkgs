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
  version = "2.12";

  src = fetchFromGitHub {
    owner = pname;
    repo = "pjproject";
    rev = version;
    sha256 = "sha256-snp9+PlffU9Ay8o42PM8SqyP60hu9nozp457HM+0bM8=";
  };

  patches = [
    ./fix-aarch64.patch
    (fetchpatch {
      name = "CVE-2022-24764.patch";
      url = "https://github.com/pjsip/pjproject/commit/560a1346f87aabe126509bb24930106dea292b00.patch";
      sha256 = "1fy78v3clm0gby7qcq3ny6f7d7f4qnn01lkqq67bf2s85k2phisg";
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
    description = "A multimedia communication library written in C, implementing standard based protocols such as SIP, SDP, RTP, STUN, TURN, and ICE";
    homepage = "https://pjsip.org/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ olynch ];
    mainProgram = "pjsua";
    platforms = platforms.linux ++ platforms.darwin;
  };
}
