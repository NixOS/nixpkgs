{ lib
, buildNpmPackage
, fetchFromGitHub
, installShellFiles
}:

buildNpmPackage rec {
  pname = "task-json-cli";
  version = "8.2.3";

  src = fetchFromGitHub {
    owner = "task-json";
    repo = "task.json-cli";
    rev = "v${version}";
    hash = "sha256-+USjDt/BIG4sD/q2M5yAWY3uSyul4t/e/8qjOoqwEoE=";
  };

  npmDepsHash = "sha256-zFGzPqN3dVJQq0LutGfcDCX9qrGrJxWPrDQVPXtuR7w=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --zsh completion/_tj
  '';

  meta = with lib; {
    description = "Command-line todo management app based on task.json format";
    homepage = "https://github.com/task-json/task.json-cli";
    license = licenses.agpl3;
    maintainers = with maintainers; [ DCsunset ];
  };
}
