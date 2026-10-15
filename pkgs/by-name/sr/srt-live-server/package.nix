{
  lib,
  fetchFromGitHub,
  stdenv,
  srt,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "srt-live-server";
  version = "1.4.8";

  src = fetchFromGitHub {
    owner = "Edward-Wu";
    repo = "srt-live-server";
    rev = "V${finalAttrs.version}";
    hash = "sha256-jfqAqUzRs7GShR/0XNQ0Zz52zyAcatSrD8v+/m7XiHQ=";
  };

  patches = [
    # https://github.com/Edward-Wu/srt-live-server/pull/94
    ./fix-insecure-printfs.patch

    # https://github.com/Edward-Wu/srt-live-server/pull/127  # adds `#include <ctime>`
    ./add-ctime-include.patch
  ];

  buildInputs = [
    srt
    zlib
  ];

  makeFlags = [
    "PREFIX=$(out)"
  ];

  meta = {
    description = "Open-source low latency livestreaming server, based on Secure Reliable Transport (SRT)";
    license = lib.licenses.mit;
    homepage = "https://github.com/Edward-Wu/srt-live-server";
    platforms = lib.platforms.linux;
  };
})
