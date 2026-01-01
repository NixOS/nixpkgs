{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  libiconv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "simdutf";
<<<<<<< HEAD
  version = "7.7.1";
=======
  version = "7.7.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "simdutf";
    repo = "simdutf";
    rev = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-/sz1GVMkHPlUkQxhbMGpoEg6byFH9WNMjEo6hjGRhE8=";
=======
    hash = "sha256-OjQHPxk4lH+h48HfkJmiWY6nnGZd/bhUcZPW7NkF5jg=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
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
=======
  meta = with lib; {
    description = "Unicode routines validation and transcoding at billions of characters per second";
    homepage = "https://github.com/simdutf/simdutf";
    license = with licenses; [
      asl20
      mit
    ];
    maintainers = with maintainers; [ wineee ];
    mainProgram = "simdutf";
    platforms = platforms.all;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
})
