{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "cppclean";
  version = "0.13";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "myint";
    repo = "cppclean";
    rev = "v${finalAttrs.version}";
    sha256 = "081bw7kkl7mh3vwyrmdfrk3fgq8k5laacx7hz8fjpchrvdrkqph0";
  };

  postUnpack = ''
    patchShebangs .
  '';

  build-system = with python3Packages; [
    setuptools
  ];

  checkPhase = ''
    ./test.bash
  '';

  meta = {
    description = "Finds problems in C++ source that slow development of large code bases";
    mainProgram = "cppclean";
    homepage = "https://github.com/myint/cppclean";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nthorne ];
    platforms = lib.platforms.linux;
  };
})
