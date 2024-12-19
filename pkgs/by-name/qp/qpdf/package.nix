{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  libjpeg,
  perl,
  zlib,

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
  version = "11.9.1";

  src = fetchFromGitHub {
    owner = "qpdf";
    repo = "qpdf";
    rev = "v${finalAttrs.version}";
    hash = "sha256-DhrOKjUPgNo61db8av0OTfM8mCNebQocQWtTWdt002s=";
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

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  preConfigure = ''
    patchShebangs qtest/bin/qtest-driver
    patchShebangs run-qtest
    # qtest needs to know where the source code is
    substituteInPlace CMakeLists.txt --replace "run-qtest" "run-qtest --top $src --code $src --bin $out"
  '';

  doCheck = true;

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
    maintainers = with lib.maintainers; [ abbradar ];
    mainProgram = "qpdf";
    platforms = lib.platforms.all;
    changelog = "https://github.com/qpdf/qpdf/blob/v${finalAttrs.version}/ChangeLog";
    pkgConfigModules = [ "libqpdf" ];
  };
})
