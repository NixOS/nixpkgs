{
  lib,
  fetchFromGitHub,
  installShellFiles,
  nixosTests,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "ssh-audit";
  version = "3.3.0";
  pyproject = true;

  outputs = [
    "out"
    "man"
  ];

  src = fetchFromGitHub {
    owner = "jtesta";
    repo = "ssh-audit";
    rev = "refs/tags/v${version}";
    hash = "sha256-sjYKQpn37zH3xpuIiZAjCn0DyLqqoQDwuz7PKDfkeTM=";
  };

  build-system = with python3Packages; [ setuptools ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installManPage $src/ssh-audit.1
  '';

  nativeCheckInputs = with python3Packages; [ pytestCheckHook ];

  passthru.tests = {
    inherit (nixosTests) ssh-audit;
  };

  meta = with lib; {
    description = "Tool for ssh server auditing";
    homepage = "https://github.com/jtesta/ssh-audit";
    changelog = "https://github.com/jtesta/ssh-audit/releases/tag/v${version}";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [
      tv
      SuperSandro2000
    ];
    mainProgram = "ssh-audit";
  };
}
