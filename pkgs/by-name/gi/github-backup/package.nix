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
<<<<<<< HEAD
  version = "0.60.0";
=======
  version = "0.51.3";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "josegonzalez";
    repo = "python-github-backup";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-dK6qkso5GOV/eZRGcwOCKn8faMuTr7czTvISLioKgVs=";
=======
    hash = "sha256-iaonBBOHu/12vzVhFnGznTKhMUy9JJc/+dTJhsSjvMo=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  meta = {
    description = "Backup a github user or organization";
    homepage = "https://github.com/josegonzalez/python-github-backup";
    changelog = "https://github.com/josegonzalez/python-github-backup/blob/${src.tag}/CHANGES.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
=======
  meta = with lib; {
    description = "Backup a github user or organization";
    homepage = "https://github.com/josegonzalez/python-github-backup";
    changelog = "https://github.com/josegonzalez/python-github-backup/blob/${src.tag}/CHANGES.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "github-backup";
  };
}
