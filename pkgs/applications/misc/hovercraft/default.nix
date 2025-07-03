{
  lib,
  buildPythonApplication,
  isPy3k,
  fetchFromGitHub,
  manuel,
  setuptools,
  docutils,
  lxml,
  svg-path,
  pygments,
  watchdog,
  fetchpatch,
}:

buildPythonApplication rec {
  pname = "hovercraft";
  version = "2.7";
  format = "setuptools";
  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "regebro";
    repo = "hovercraft";
    rev = version;
    sha256 = "0k0gjlqjz424rymcfdjpj6a71ppblfls5f8y2hd800d1as4im8az";
  };

  nativeCheckInputs = [ manuel ];
  propagatedBuildInputs = [
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
      sha256 = "sha256-qz4Kp4MxlS3KPKRB5/VESCI++66U9q6cjQ0cHy3QjTc=";
    })
  ];

  meta = with lib; {
    description = "Makes impress.js presentations from reStructuredText";
    mainProgram = "hovercraft";
    homepage = "https://github.com/regebro/hovercraft";
    license = licenses.mit;
    maintainers = with maintainers; [ makefu ];
  };
}
