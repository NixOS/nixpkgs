{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools-scm,
  pytubefix,
  requests,
  devgoldyutils,
}:

buildPythonPackage rec {
  pname = "mov-cli-test";
  version = "1.1.7";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "mov-cli";
    repo = "mov-cli-test";
    rev = "refs/tags/${version}";
    hash = "sha256-INdPAJxPxfo5bKg4Xn1r7bildxznXrTJxmDI21wylnI=";
  };

  doCheck = false;

  propagatedBuildInputs = [
    pytubefix
    requests
    devgoldyutils
  ];

  nativeBuildInputs = [ setuptools-scm ];

  meta = {
    description = "Mov-cli plugin that let's you test mov-cli's capabilities by watching free films and animations in the creative commons";
    homepage = "https://github.com/mov-cli/mov-cli-test";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ youhaveme9 ];
  };
}
