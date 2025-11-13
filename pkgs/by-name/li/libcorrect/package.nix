{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "libcorrect";
  version = "0-unstable-2018-10-10";

  src = fetchFromGitHub {
    owner = "quiet";
    repo = "libcorrect";
    rev = "f5a28c74fba7a99736fe49d3a5243eca29517ae9";
    hash = "sha256-78OgoQFVcBWAqOSfYnygzryxfGwbdWbudl3MUDqaiWE=";
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "cmake_minimum_required(VERSION 2.8)" "cmake_minimum_required(VERSION 3.10)"
  '';

  nativeBuildInputs = [ cmake ];

  meta = {
    description = "C library for Convolutional codes and Reed-Solomon";
    homepage = "https://github.com/quiet/libcorrect";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ noderyos ];
  };
})
