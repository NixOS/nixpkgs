{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  libjpeg,
  perl,
  zlib,
  ctestCheckHook,

  # for passthru.tests
  cups-filters,
  pdfmixtool,
  pdfslicer,
  python3,
  testers,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "qpdf";
  version = "12.2.0";

  src = fetchFromGitHub {
    owner = "qpdf";
    repo = "qpdf";
    tag = "v${finalAttrs.version}";
    hash = "sha256-tzOZVQ/XO2mWNtz3mFTdrpdD2PvvCwje5nbEyiIkcZw=";
  };

  outputs = [
    "bin"
    "doc"
    "lib"
    "man"
    "out"
  ];

  nativeBuildInputs = [
    cmake
    perl
  ];

  buildInputs = [
    zlib
    libjpeg
  ];

  nativeCheckInputs = [ ctestCheckHook ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  cmakeFlags = [
    (lib.cmakeBool "SHOW_FAILED_TEST_OUTPUT" true)
  ];

  preConfigure = ''
    patchShebangs qtest/bin/qtest-driver
    patchShebangs run-qtest
    # qtest needs to know where the source code is
    substituteInPlace CMakeLists.txt --replace "run-qtest" "run-qtest --top $src --code $src --bin $out"
  '';

  doCheck = true;

  # Cursed system‐dependent(?!) failure with libc++ because another
  # test in the same process sets the global locale; skip for now.
  #
  # See:
  # * <https://github.com/llvm/llvm-project/issues/39399>
  # * <https://github.com/llvm/llvm-project/issues/123309>
  ${if stdenv.cc.libcxx != null then "patches" else null} = [
    ./disable-timestamp-test.patch
  ];

  passthru.tests = {
    pkg-config = testers.hasPkgConfigModules { package = finalAttrs.finalPackage; };
    inherit (python3.pkgs) pikepdf;
    inherit
      cups-filters
      pdfmixtool
      pdfslicer
      ;
  };

  meta = {
    homepage = "https://qpdf.sourceforge.io/";
    description = "C++ library and set of programs that inspect and manipulate the structure of PDF files";
    license = lib.licenses.asl20; # as of 7.0.0, people may stay at artistic2
    maintainers = [ lib.maintainers.dotlambda ];
    mainProgram = "qpdf";
    platforms = lib.platforms.all;
    changelog = "https://qpdf.readthedocs.io/en/${lib.versions.majorMinor finalAttrs.version}/release-notes.html";
    pkgConfigModules = [ "libqpdf" ];
  };
})
