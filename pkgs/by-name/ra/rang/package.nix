{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rang";
  version = "3.3";

  src = fetchFromGitHub {
    owner = "agauniyal";
    repo = "rang";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YJn9SnTBAJ/lPhBRjIlFgRRageeX3wximuAvbXyhgfg=";
  };

  nativeBuildInputs = [ cmake ];

  meta = {
    description = "Minimal, Header only Modern c++ library for terminal goodies";
    homepage = "https://agauniyal.github.io/rang/";
    license = lib.licenses.unlicense;
    maintainers = [ ];
  };
})
