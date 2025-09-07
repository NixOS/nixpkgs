{
  lib,
  fetchFromGitHub,
  python3Packages,
  fetchpatch,
}:

python3Packages.buildPythonApplication rec {
  pname = "hovercraft";
  version = "2.7";
  format = "setuptools";
  disabled = !python3Packages.isPy3k;

  src = fetchFromGitHub {
    owner = "regebro";
    repo = "hovercraft";
    tag = version;
    hash = "sha256-X6EaiVahAYAaFB65oqmj695wlJFXNseqz0SQLzGVD0w=";
  };

  nativeCheckInputs = with python3Packages; [ manuel ];

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
    maintainers = with lib.maintainers; [ makefu ];
  };
}
