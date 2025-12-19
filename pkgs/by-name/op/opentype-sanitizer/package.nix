{
  lib,
  stdenv,
  fetchFromGitHub,
  freetype,
  gtest,
  lz4,
  meson,
  ninja,
  pkg-config,
  woff2,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "opentype-sanitizer";
  version = "9.2.0";

  src = fetchFromGitHub {
    owner = "khaledhosny";
    repo = "ots";
    rev = "v${finalAttrs.version}";
    hash = "sha256-QRbF2GUDQsp8i6qVYlafSb9HaaozRuJ8dn1mhMMLeLc=";
  };

  mesonFlags = [ "-Dcpp_std=c++17" ]; # required by gtest

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

  meta = {
    description = "Sanitizing parser for OpenType fonts";
    homepage = "https://github.com/khaledhosny/ots";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ danc86 ];
  };
})
