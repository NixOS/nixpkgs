{
  lib,
  python3,
  python3Packages,
  fetchFromGitLab,
  fetchpatch,
  rspamd,
  nixosTests,
}:

python3Packages.buildPythonApplication {
  pname = "rspamd-trainer";
  version = "unstable-2023-11-27";
  format = "pyproject";

  src = fetchFromGitLab {
    owner = "onlime";
    repo = "rspamd-trainer";
    rev = "eb6639a78a019ade6781f3a8418eddc030f8fa14";
    hash = "sha256-Me6WZhQ6SvDGGBQQtSA/7bIfKtsz6D5rvQeU12sVzgY=";
  };

  patches = [
    # Refactor pyproject.toml
    # https://gitlab.com/onlime/rspamd-trainer/-/merge_requests/2
    (fetchpatch {
      url = "https://gitlab.com/onlime/rspamd-trainer/-/commit/8824bfb9a9826988a90a401b8e51c20f5366ed70.patch";
      hash = "sha256-qiXfwMUfM/iV+fHba8xdwQD92RQz627+HdUTgwgRZdc=";
      name = "refactor_pyproject.patch";
    })
  ];

  postPatch = ''
    # Fix module path not applied by patch
    mv helper src/
    touch src/helper/__init__.py
    mv settings.py src/rspamd_trainer/
    sed -i 's/from settings/from .settings/' src/rspamd_trainer/run.py

    # Fix rspamc path
    sed -i "s|/usr/bin/rspamc|${rspamd}/bin/rspamc|" src/rspamd_trainer/run.py
  '';

  nativeBuildInputs = with python3.pkgs; [
    setuptools-scm
  ];

  propagatedBuildInputs = with python3.pkgs; [
    python-dotenv
    imapclient
  ];

  passthru.tests = { inherit (nixosTests) rspamd-trainer; };

  meta = {
    homepage = "https://gitlab.com/onlime/rspamd-trainer";
    description = "Grabs messages from a spam mailbox via IMAP and feeds them to Rspamd for training";
    mainProgram = "rspamd-trainer";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ onny ];
  };
}
