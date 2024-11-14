{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
}:

buildPythonPackage rec {
  pname = "poetry-plugin-poeblix";
  version = "0.10.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "spoorn";
    repo = "poeblix";
    rev = "refs/tags/${version}";
    hash = "sha256-TKadEOk9kM3ZYsQmE2ftzjHNGNKI17p0biMr+Nskigs=";
  };

  postPatch = ''
    sed -i '/poetry =/d' pyproject.toml
  '';

  nativeBuildInputs = [
    poetry-core
  ];

  doCheck = false;
  pythonImportsCheck = ["poeblix"];

  meta = with lib; {
    changelog = "https://github.com/spoorn/poeblix/releases/tag/${lib.removePrefix "refs/tags/" src.rev}";
    description = "Poetry Plugin that adds various features that extend the poetry command such as building wheel files with locked dependencies, and validations of wheel/docker containers";
    license = licenses.mit;
    homepage = "https://github.com/spoorn/poeblix";
    maintainers = with maintainers; [ hennk ];
  };
}
