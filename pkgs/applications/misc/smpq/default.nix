{ lib, stdenv, fetchurl, cmake, stormlib }:

stdenv.mkDerivation rec {
  pname = "smpq";
  version = "1.6";

  src = fetchurl {
    url = "https://launchpad.net/smpq/trunk/${version}/+download/${pname}_${version}.orig.tar.gz";
    sha256 = "1jqq5x3b17jy66x3kkf5hs5l322dx2v14djxxrqrnqp8bn5drlmm";
  };

  cmakeFlags = [
    "-DWITH_KDE=OFF"
  ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [ stormlib ];

  meta = with lib; {
    description = "StormLib MPQ archiving utility";
    homepage = "https://launchpad.net/smpq";
    license = licenses.gpl3Only;
    platforms = platforms.all;
    maintainers = with maintainers; [ aanderse karolchmist ];
  };
}
