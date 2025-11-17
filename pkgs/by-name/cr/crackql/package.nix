{
  lib,
  fetchFromGitHub,
  nix-update-script,
  python3,
}:

python3.pkgs.buildPythonApplication {
  pname = "crackql";
  version = "1.0-unstable-2023-08-18";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "nicholasaleks";
    repo = "CrackQL";
    # tag = version;
    # Switch to tag (and remove the extraArgs from the updateScript) next update
    rev = "ac26a44c2dd201f65da0d1c3f95eaf776ed1b2dd";
    hash = "sha256-XlHbGkwdOV1nobjtQP/M3IIEuzXHBuwf52EsXf3MWoM=";
  };

  pythonRelaxDeps = [
    "graphql-core"
  ];

  nativeBuildInputs = with python3.pkgs; [
    poetry-core
  ];

  propagatedBuildInputs = with python3.pkgs; [
    requests
    graphql-core
    jinja2
    typing-extensions
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = with lib; {
    description = "GraphQL password brute-force and fuzzing utility";
    mainProgram = "crackql";
    homepage = "https://github.com/nicholasaleks/CrackQL";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ fab ];
  };
}
