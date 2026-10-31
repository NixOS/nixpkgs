{
  lib,
  fetchFromGitHub,
  pythonPackages,
  mopidy,
}:

pythonPackages.buildPythonApplication (finalAttrs: {
  pname = "mopidy-soundcloud";
  version = "4.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mopidy";
    repo = "mopidy-soundcloud";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-3t04O9jtFe4VNl9im1sC/FY4/tTD+yQIfd+vh02VD3E=";
  };

  build-system = [
    pythonPackages.setuptools
    pythonPackages.setuptools-scm
  ];

  dependencies = [
    mopidy
    pythonPackages.beautifulsoup4
    pythonPackages.requests
  ];

  doCheck = false;

  pythonImportsCheck = [ "mopidy_soundcloud" ];

  meta = {
    description = "Mopidy extension for playing music from SoundCloud";
    homepage = "https://github.com/mopidy/mopidy-soundcloud";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
