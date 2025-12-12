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
  version = "0.55.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "josegonzalez";
    repo = "python-github-backup";
    tag = version;
    hash = "sha256-28u21SO6G1lrMq6Ihl+tRSit5Jh9w2mwjK+3r3YfH5M=";
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
