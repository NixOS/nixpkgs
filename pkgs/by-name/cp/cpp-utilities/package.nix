{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  cppunit,
  libiconv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cpp-utilities";
<<<<<<< HEAD
  version = "5.32.0";
=======
  version = "5.31.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "Martchus";
    repo = "cpp-utilities";
    rev = "v${finalAttrs.version}";
<<<<<<< HEAD
    sha256 = "sha256-NiCUbo00o4rYY0cKwWGz0e2LfJPcRSs1PY6NBlnj9G8=";
=======
    sha256 = "sha256-HpzcGHDudVFmkVfkn5YpAATKfZ3FpIKXfqhpjpehK1M=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  nativeBuildInputs = [ cmake ];
  nativeCheckInputs = [ cppunit ];
  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv # needed on Darwin, see https://github.com/Martchus/cpp-utilities/issues/4
  ];

  cmakeFlags = [ "-DBUILD_SHARED_LIBS=ON" ];

  # Otherwise, tests fail since the resulting shared object libc++utilities.so is only available in PWD of the make files
  preCheck = ''
    checkFlagsArray+=(
      "LD_LIBRARY_PATH=$PWD"
    )
  '';
  # tests fail on Darwin
  doCheck = !stdenv.hostPlatform.isDarwin;

<<<<<<< HEAD
  meta = {
    homepage = "https://github.com/Martchus/cpp-utilities";
    description = "Common C++ classes and routines used by @Martchus' applications featuring argument parser, IO and conversion utilities";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ doronbehar ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
=======
  meta = with lib; {
    homepage = "https://github.com/Martchus/cpp-utilities";
    description = "Common C++ classes and routines used by @Martchus' applications featuring argument parser, IO and conversion utilities";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ doronbehar ];
    platforms = platforms.linux ++ platforms.darwin;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
})
