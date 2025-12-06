{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchzip,
  cmake,
  catch2,
  fmt,
  python3,
}:

let
  ucd-version = "16.0.0";

  ucd-src = fetchzip {
    url = "https://www.unicode.org/Public/${ucd-version}/ucd/UCD.zip";
    hash = "sha256-GgEYjOLrxxfTAQsc2bpi7ShoAr3up8z7GXXpe+txFuw";
    stripRoot = false;
  };
in
stdenv.mkDerivation (final: {
  pname = "libunicode";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "contour-terminal";
    repo = "libunicode";
    rev = "v${final.version}";
    hash = "sha256-zX33aTQ7Wgl8MABu+o6nA2HWrfXD4zQ9b3NDB+T2saI";
  };

  # Fix: set_target_properties Can not find target to add properties to: Catch2, et al.
  patches = [ ./remove-target-properties.diff ];

  nativeBuildInputs = [
    cmake
    python3
  ];
  buildInputs = [
    catch2
    fmt
  ];

  cmakeFlags = [ "-DLIBUNICODE_UCD_DIR=${ucd-src}" ];

  meta = with lib; {
    description = "Modern C++20 Unicode library";
    mainProgram = "unicode-query";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ moni ];
  };
})
