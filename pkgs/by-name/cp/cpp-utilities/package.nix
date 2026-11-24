{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  cppunit,
  libiconv,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cpp-utilities";
  version = "5.37.0";

  src = fetchFromGitHub {
    owner = "Martchus";
    repo = "cpp-utilities";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/1YkxIS23YAhzrBJouZAJkOIHe/kaT5R3R+tHEDMuLk=";
  };

  nativeBuildInputs = [ cmake ];

  checkInputs = [ cppunit ];

  strictDeps = true;

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv # needed on Darwin, see https://github.com/Martchus/cpp-utilities/issues/4
  ];

  cmakeFlags = [ "-DBUILD_SHARED_LIBS=ON" ];

  # Otherwise, tests fail since the resulting shared object libc++utilities.so is only available in PWD of the make files
  checkFlags = [
    "LD_LIBRARY_PATH=$(PWD)"
  ];

  # tests fail on Darwin
  doCheck = !stdenv.hostPlatform.isDarwin;

  passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;

  __structuredAttrs = true;

  meta = {
    homepage = "https://github.com/Martchus/cpp-utilities";
    description = "Common C++ classes and routines used by @Martchus' applications featuring argument parser, IO and conversion utilities";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ doronbehar ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    pkgConfigModules = [ "c++utilities" ];
  };
})
