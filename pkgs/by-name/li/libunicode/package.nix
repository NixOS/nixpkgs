{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchzip,
  cmake,
  catch2_3,
  fmt,
  python3,
  simdImplementation ? "none", # see https://github.com/contour-terminal/libunicode/blob/v0.7.0/CMakeLists.txt#L53 for options
}:

let
  ucd-version = "17.0.0";

  ucd-src = fetchzip {
    url = "https://www.unicode.org/Public/${ucd-version}/ucd/UCD.zip";
    hash = "sha256-k2OFy8xPvn+Bboyr1EsmZNeVDOglvk2kSZ+H17YaX60=";
    stripRoot = false;
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "libunicode";
  version = "0.9.4";

  src = fetchFromGitHub {
    owner = "contour-terminal";
    repo = "libunicode";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vHJ1o3rP5LjKZzhSFN5RUWAgY69z80H8oWi86h/CjVI=";
  };

  nativeBuildInputs = [
    cmake
    python3
  ];
  buildInputs = [
    catch2_3
    fmt
  ];

  cmakeFlags = [
    (lib.cmakeFeature "LIBUNICODE_SIMD_IMPLEMENTATION" simdImplementation)
    (lib.cmakeFeature "LIBUNICODE_UCD_DIR" "${ucd-src}")
  ];

  meta = {
    description = "Modern C++20 Unicode library";
    homepage = "https://github.com/contour-terminal/libunicode";
    mainProgram = "unicode-query";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ moni ];
  };
})
