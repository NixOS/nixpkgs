{ lib, buildPythonApplication, fetchFromGitHub, pillow, click, cython, scipy, flask, gevent, numpy, scikitimage, loguru }:

buildPythonApplication rec {
  pname = "wallgen";
  version = "unstable-2021-02-21";

  src = fetchFromGitHub {
    owner = "SubhrajitPrusty";
    repo = "wallgen";
    rev = "cf9cfbd35d6c54fc3679833784ebbdc85e3a5aea";
    sha256 = "sha256-OdJiecevw2rSzotcmARil/YQZgHoBrtPBKjrDv4e1qE=";
  };

  propagatedBuildInputs = [
    pillow
    click
    cython
    scipy
    flask
    gevent
    numpy
    scikitimage
    loguru
  ];

  meta = with lib; {
    maintainers = with maintainers; [ j0hax ];
    description = "Generate HQ poly wallpapers";
    homepage = "https://github.com/SubhrajitPrusty/wallgen";
    license = licenses.mit;
  };
}
