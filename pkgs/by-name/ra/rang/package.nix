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

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "cmake_minimum_required(VERSION 3.1)" "cmake_minimum_required(VERSION 3.10)"
  '';

  nativeBuildInputs = [ cmake ];

  meta = {
    description = "Minimal, Header only Modern c++ library for terminal goodies";
    homepage = "https://agauniyal.github.io/rang/";
    license = lib.licenses.unlicense;
    maintainers = [ lib.maintainers.HaoZeke ];
  };
}
