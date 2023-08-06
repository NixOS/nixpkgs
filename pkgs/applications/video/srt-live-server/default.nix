{ lib
, fetchFromGitHub
, stdenv
, srt
, zlib
}:

stdenv.mkDerivation rec {
  pname = "srt-live-server";
  version = "1.4.8";

  src = fetchFromGitHub {
    owner = "Edward-Wu";
    repo = "srt-live-server";
    rev = "V${version}";
    sha256 = "0x48sxpgxznb1ymx8shw437pcgk76ka5rx0zhn9b3cyi9jlq1yld";
  };

  patches = [
    # https://github.com/Edward-Wu/srt-live-server/pull/94
    ./fix-insecure-printfs.patch

    # https://github.com/Edward-Wu/srt-live-server/pull/127  # adds `#include <ctime>`
    ./add-ctime-include.patch
  ];

  buildInputs = [ srt zlib ];

  makeFlags = [
    "PREFIX=$(out)"
  ];

  meta = with lib; {
    description = "srt live server for low latency";
    license = licenses.mit;
    homepage = "https://github.com/Edward-Wu/srt-live-server";
    maintainers = with maintainers; [ shamilton ];
    platforms = platforms.linux;
  };
}
