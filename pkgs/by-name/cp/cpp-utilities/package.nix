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
  version = "5.26.1";

  src = fetchFromGitHub {
    owner = "Martchus";
    repo = "cpp-utilities";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-ft8gusZ6We3nEAOwccGrUidxpO5tdWR5VNDQ/r5l2P8=";
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

  meta = with lib; {
    homepage = "https://github.com/Martchus/cpp-utilities";
    description = "Common C++ classes and routines used by @Martchus' applications featuring argument parser, IO and conversion utilities";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ doronbehar ];
    platforms = platforms.linux ++ platforms.darwin;
  };
})
