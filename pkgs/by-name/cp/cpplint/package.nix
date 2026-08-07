{
  lib,
  python3Packages,
  fetchFromGitHub,
  fetchpatch2,
  versionCheckHook,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "cpplint";
  version = "2.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cpplint";
    repo = "cpplint";
    tag = finalAttrs.version;
    hash = "sha256-4crTuqynQt8Nyjqea6DpREtLy7ydRF0hNVnc7tUnO1k=";
  };

  # Fix Python 3.14 test failures. Remove with the next release.
  patches = [
    (fetchpatch2 {
      name = "drop-codecs-open.patch";
      url = "https://github.com/cpplint/cpplint/commit/89bff410afed72e58d23ae084de4103986ea8630.patch?full_index=1";
      hash = "sha256-Jdeewj3GM7GMoRF7+Qz/9n1hc8PYPcXLgtSGwSUpT1E=";
    })
    (fetchpatch2 {
      name = "use-universal-newlines.patch";
      url = "https://github.com/cpplint/cpplint/commit/d15a8715a6e848f784fda700758c4ac2d252fd31.patch?full_index=1";
      hash = "sha256-Oo2doknEGnuxDJA0y17n1DCaKwadtMW/14a5wnIgfkw=";
    })
  ];

  # We use pytest-cov-stub instead
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail '"pytest-cov",' ""
  '';

  build-system = with python3Packages; [
    setuptools
  ];

  nativeCheckInputs = with python3Packages; [
    parameterized
    pytest-cov-stub
    pytest-timeout
    pytestCheckHook
    testfixtures
    versionCheckHook
  ];

  meta = {
    homepage = "https://github.com/cpplint/cpplint";
    description = "Static code checker for C++";
    changelog = "https://github.com/cpplint/cpplint/releases/tag/${finalAttrs.version}";
    mainProgram = "cpplint";
    license = lib.licenses.bsd3;
  };
})
