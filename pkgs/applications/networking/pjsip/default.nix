{ lib, stdenv, fetchFromGitHub, openssl, libsamplerate, alsa-lib, AppKit, fetchpatch }:

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
    description = "A multimedia communication library written in C, implementing standard based protocols such as SIP, SDP, RTP, STUN, TURN, and ICE";
    homepage = "https://pjsip.org/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ olynch ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
