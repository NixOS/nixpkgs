{
  lib,
  fetchFromGitHub,
  python3Packages,
  nix-update-script,
}:

python3Packages.buildPythonApplication rec {
  pname = "lieer";
  version = "1.6";
  format = "pyproject";

  passthru.updateScript = nix-update-script { };

  src = fetchFromGitHub {
    owner = "gauteh";
    repo = "lieer";
    tag = "v${version}";
    sha256 = "sha256-U3+Y634oGmvIrvcbSKrrJ8PzLRsMoN0Fd/+d9WE1Q7U=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    notmuch2
    google-api-python-client
    google-auth-oauthlib
    tqdm
  ];

  # no tests
  doCheck = false;

  pythonImportsCheck = [
    "lieer"
  ];

  meta = with lib; {
    description = "Fast email-fetching and two-way tag synchronization between notmuch and GMail";
    longDescription = ''
      This program can pull email and labels (and changes to labels)
      from your GMail account and store them locally in a maildir with
      the labels synchronized with a notmuch database. The changes to
      tags in the notmuch database may be pushed back remotely to your
      GMail account.
    '';
    homepage = "https://lieer.gaute.vetsj.com/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [
      archer-65
      flokli
    ];
    mainProgram = "gmi";
  };
}
