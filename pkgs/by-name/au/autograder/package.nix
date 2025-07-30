{
  lib,
  python3Packages,
  fetchFromGitHub,
  digital,
  git,
  gnused,
  jre,
  nix-update-script,
}:

python3Packages.buildPythonApplication {
  pname = "autograder";
  version = "0-unstable-2026-10-27";
  __structuredAttrs = true;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "usfca-cs-tools";
    repo = "autograder";
    rev = "426d78088ea7e9bf9a54ed7d348c7a5b57eefeab";
    hash = "sha256-WTPRTKwtmQlyz/kO5IRT80j7HaiySVdE1TtFRbFNJNA=";
  };

  build-system = with python3Packages; [ setuptools ];

  # Development tools listed as runtime dependencies upstream
  pythonRemoveDeps = [
    "autopep8"
    "pep8"
    "pylint"
    "pytest"
  ];

  dependencies = with python3Packages; [
    requests
    simple-term-menu
    tomlkit
  ];

  # Default Digital.jar and Dockerfile paths
  postPatch = ''
    substituteInPlace src/autograder/actions/test.py \
      --replace-fail '~/Digital/Digital.jar' '${digital}/share/java/Digital.jar'
    substituteInPlace src/autograder/actions/container.py \
      --replace-fail 'self.dockerfiles_path = ""' "self.dockerfiles_path = \"$out/share/autograder/containers\""
  '';

  postInstall = ''
    mkdir -p $out/share/autograder
    cp -r containers $out/share/autograder/
  '';

  # Git and sed for cloning; JRE for Digital tests, after any user-provided one
  makeWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath [
      git
      gnused
    ])
    "--suffix"
    "PATH"
    ":"
    (lib.makeBinPath [ jre ])
  ];

  nativeCheckInputs = with python3Packages; [ pytestCheckHook ];

  pythonImportsCheck = [ "autograder" ];

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Clone and build repos from GitHub Classroom";
    longDescription = ''
      `grade` is a tool for Computer Science students and instructors
      to test student projects for correctness.
    '';
    homepage = "https://github.com/usfca-cs-tools/autograder";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "grade";
  };
}
