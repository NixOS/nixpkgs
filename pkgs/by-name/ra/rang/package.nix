{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "rang";
  version = "3.2";

  src = fetchFromGitHub {
    owner = "agauniyal";
    repo = "rang";
    tag = "v${version}";
    hash = "sha256-NK7jB5ijcu9OObmfLgiWxlJi4cVAhr7p6m9HKf+5TnQ=";
  };

  nativeBuildInputs = [ cmake ];

  meta = {
    description = "Minimal, Header only Modern c++ library for terminal goodies";
    homepage = "https://agauniyal.github.io/rang/";
    license = lib.licenses.unlicense;
    maintainers = [ lib.maintainers.HaoZeke ];
  };
}
