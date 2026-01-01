{
  lib,
  fetchFromGitHub,
  python3Packages,
  fetchpatch,
}:

python3Packages.buildPythonApplication rec {
  pname = "hovercraft";
  version = "2.7";
<<<<<<< HEAD
  pyproject = true;
=======
  format = "setuptools";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  disabled = !python3Packages.isPy3k;

  src = fetchFromGitHub {
    owner = "regebro";
    repo = "hovercraft";
    tag = version;
    hash = "sha256-X6EaiVahAYAaFB65oqmj695wlJFXNseqz0SQLzGVD0w=";
  };

<<<<<<< HEAD
  build-system = [ python3Packages.setuptools ];

  nativeCheckInputs = [ python3Packages.manuel ];
=======
  nativeCheckInputs = with python3Packages; [ manuel ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  dependencies = with python3Packages; [
    setuptools
    docutils
    lxml
    svg-path
    pygments
    watchdog
  ];
  patches = [
    (fetchpatch {
      name = "fix tests with pygments 2.14";
      url = "https://sources.debian.org/data/main/h/hovercraft/2.7-5/debian/patches/0003-Fix-tests-with-pygments-2.14.patch";
      hash = "sha256-qz4Kp4MxlS3KPKRB5/VESCI++66U9q6cjQ0cHy3QjTc=";
    })
  ];

  meta = {
    description = "Makes impress.js presentations from reStructuredText";
    mainProgram = "hovercraft";
    homepage = "https://github.com/regebro/hovercraft";
    license = lib.licenses.mit;
<<<<<<< HEAD
    maintainers = [ lib.maintainers.makefu ];
=======
    maintainers = with lib.maintainers; [ makefu ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
