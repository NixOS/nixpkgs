{ lib, stdenv, fetchurl, cmake, StormLib }:

stdenv.mkDerivation {
  pname = "smpq";
  version = "1.6";

  src = fetchurl {
    url = "https://launchpad.net/smpq/trunk/1.6/+download/smpq_1.6.orig.tar.gz";
    sha256 = "1jqq5x3b17jy66x3kkf5hs5l322dx2v14djxxrqrnqp8bn5drlmm";
  };

  cmakeFlags = [
    "-DWITH_KDE=OFF"
  ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [ StormLib ];

  meta = with lib; {
    description = "StormLib MPQ archiving utility";
    homepage = "https://launchpad.net/smpq";
    license = licenses.gpl3Only;
    platforms = platforms.all;
    maintainers = with maintainers; [ aanderse karolchmist ];
  };
}
