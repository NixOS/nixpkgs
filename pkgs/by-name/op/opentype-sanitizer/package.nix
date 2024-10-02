{ lib
, stdenv
, fetchFromGitHub
, freetype
, gtest
, lz4
, meson
, ninja
, pkg-config
, woff2
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "opentype-sanitizer";
  version = "9.1.0";

  src = fetchFromGitHub {
    owner = "khaledhosny";
    repo = "ots";
    rev = "v${finalAttrs.version}";
    hash = "sha256-gsNMPNPcfHyOgjJnIrJ5tLYHbCfIfTowEhcaGOUPb2Q=";
  };

  mesonFlags = [ "-Dcpp_std=c++14" ];

  buildInputs = [
    freetype
    gtest
    lz4
    woff2
  ];
  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  doCheck = true;

  meta = with lib; {
    description = "Sanitizing parser for OpenType fonts";
    homepage = "https://github.com/khaledhosny/ots";
    license = licenses.bsd3;
    maintainers = with maintainers; [ danc86 ];
  };
})
