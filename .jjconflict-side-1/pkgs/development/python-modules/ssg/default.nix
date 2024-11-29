{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,

  python,
  unittestCheckHook,
  setuptools,

  fire,
  python-crfsuite,
  tqdm,
}:

buildPythonPackage {
  pname = "ssg";
  version = "0.0.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ponrawee";
    repo = "ssg";
    rev = "d1b811ef4f8ac08ba1db839f426ba6b6a8e0eb38";
    hash = "sha256-GBZzVDDfKOTnbcrIxhFRiNHXN2pSNU3T9RvUytJ068w=";
  };

  patches = [
    (fetchpatch {
      name = "fix-deprecation-warnings-and-bump-version";
      url = "https://patch-diff.githubusercontent.com/raw/ponrawee/ssg/pull/10.patch";
      hash = "sha256-4O1fpI0FBUG/3RN+PAi7I8vpgYmPPL5ZMXhoZUFsQy8=";
    })
  ];

  build-system = [ setuptools ];

  dependencies = [
    fire
    python-crfsuite
    tqdm
  ];

  nativeCheckInputs = [ unittestCheckHook ];

  pythonImportsCheck = [ "ssg" ];

  postInstall = "rm -rf $out/${python.sitePackages}/scripts";

  meta = with lib; {
    description = "TCRF syllable segmenter for Thai";
    homepage = "https://github.com/ponrawee/ssg";
    license = licenses.asl20;
    maintainers = with maintainers; [ vizid ];
    mainProgram = "ssg-cli";
  };
}
