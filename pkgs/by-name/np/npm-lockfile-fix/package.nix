{
  lib,
  python3,
  fetchFromGitHub,
  nix-update-script,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "npm-lockfile-fix";
  version = "0.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jeslie0";
    repo = "npm-lockfile-fix";
    rev = "v${version}";
    hash = "sha256-P93OowrVkkOfX5XKsRsg0c4dZLVn2ZOonJazPmHdD7g=";
  };

  build-system = with python3.pkgs; [
    setuptools
  ];

  dependencies = with python3.pkgs; [
    requests
  ];

  doCheck = false; # no tests

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Add missing integrity and resolved fields to a package-lock.json file";
    homepage = "https://github.com/jeslie0/npm-lockfile-fix";
    mainProgram = "npm-lockfile-fix";
    license = lib.licenses.mit;
    maintainers = with maintainers; [
      lucasew
      felschr
    ];
  };
}
