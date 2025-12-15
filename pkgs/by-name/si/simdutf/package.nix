{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  libiconv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "simdutf";
  version = "7.7.0";

  src = fetchFromGitHub {
    owner = "simdutf";
    repo = "simdutf";
    rev = "v${finalAttrs.version}";
    hash = "sha256-OjQHPxk4lH+h48HfkJmiWY6nnGZd/bhUcZPW7NkF5jg=";
  };

  # Fix build on darwin
  postPatch = ''
    substituteInPlace tools/CMakeLists.txt --replace "-Wl,--gc-sections" ""
  '';

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    libiconv
  ];

  meta = {
    description = "Unicode routines validation and transcoding at billions of characters per second";
    homepage = "https://github.com/simdutf/simdutf";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ wineee ];
    mainProgram = "simdutf";
    platforms = lib.platforms.all;
  };
})
