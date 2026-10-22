{
  lib,
  python3Packages,
  fetchFromGitHub,
  installShellFiles,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "git-imerge";
  version = "1.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mhagger";
    repo = "git-imerge";
    tag = "v${finalAttrs.version}";
    hash = "sha256-17xUe1N4igx5HOZBU+q7UQxkpHOFQozhR18hUYuPVuo=";
  };

  build-system = [ python3Packages.setuptools ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --bash completions/git-imerge
  '';

  meta = {
    homepage = "https://github.com/mhagger/git-imerge";
    description = "Perform a merge between two branches incrementally";
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
    mainProgram = "git-imerge";
  };
})
