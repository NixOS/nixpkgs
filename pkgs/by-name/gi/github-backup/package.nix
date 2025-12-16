{
  lib,
  python3Packages,
  cacert,
  fetchFromGitHub,
  git,
  git-lfs,
  versionCheckHook,
}:

python3Packages.buildPythonApplication rec {
  pname = "github-backup";
  version = "0.57.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "josegonzalez";
    repo = "python-github-backup";
    tag = version;
    hash = "sha256-ISJBa+fyj+ko8dW4x1yIo7tlWT8Jlylbo4lzq23whOg=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  makeWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath [
      git
      git-lfs
    ])
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  env.SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";

  versionCheckKeepEnvironment = [ "SSL_CERT_FILE" ];

  meta = {
    description = "Backup a github user or organization";
    homepage = "https://github.com/josegonzalez/python-github-backup";
    changelog = "https://github.com/josegonzalez/python-github-backup/blob/${src.tag}/CHANGES.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
    mainProgram = "github-backup";
  };
}
