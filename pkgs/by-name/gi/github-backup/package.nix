{
  lib,
  python3Packages,
  cacert,
  fetchFromGitHub,
  git,
  git-lfs,
  versionCheckHook,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "github-backup";
  version = "0.61.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "josegonzalez";
    repo = "python-github-backup";
    tag = finalAttrs.version;
    hash = "sha256-iZM/gXjEBJpqCkW54quNVsr6zrfAfRrcdRy6icecMHk=";
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
    changelog = "https://github.com/josegonzalez/python-github-backup/blob/${finalAttrs.src.tag}/CHANGES.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
    mainProgram = "github-backup";
  };
})
