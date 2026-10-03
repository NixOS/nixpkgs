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
    hash = "sha256-AF48c9sZsisd+vB0phQtE+Hnxsyu1ez5HrAeOufhKyA=";
  };

  postUnpack = ''
    patchShebangs .
  '';

  postPatch = ''
    # Fix Python 3.14 compat
    substituteInPlace setup.py \
      --replace-fail 'value.s' 'value.value'
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
