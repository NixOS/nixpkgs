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
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "contour-terminal";
    repo = "libunicode";
    tag = "v${finalAttrs.version}";
    hash = "sha256-J8qawT1oiUO9xTVEMQvsY0K2NtIfkUq9PoCbFt6wqek=";
  };

  # Fix: set_target_properties Can not find target to add properties to: Catch2, et al.
  patches = [ ./remove-target-properties.diff ];

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
    mainProgram = "unicode-query";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ moni ];
  };
})
