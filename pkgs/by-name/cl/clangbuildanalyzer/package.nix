{
  stdenv,
  lib,
  cmake,
  fetchFromGitHub,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "clangbuildanalyzer";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "aras-p";
    repo = "ClangBuildAnalyzer";
    rev = "v${finalAttrs.version}";
    hash = "sha256-GIMQZGPFKDrfMqCsA8nR3O8Hzp2jcaZ+yDrPeCxTsIg=";
  };

  nativeBuildInputs = [
    cmake
  ];

  meta = {
    description = "Tool for analyzing Clang's -ftime-trace files";
    homepage = "https://github.com/aras-p/ClangBuildAnalyzer";
    maintainers = [ ];
    license = lib.licenses.unlicense;
    platforms = lib.platforms.unix;
    mainProgram = "ClangBuildAnalyzer";
  };
})
