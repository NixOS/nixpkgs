{ lib
, fetchFromGitHub
, python3Packages
}:

python3Packages.buildPythonApplication rec {
  pname = "lieer";
  version = "1.5";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "gauteh";
    repo = "lieer";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-z3OGCjLsOi6K1udChlSih8X6e2qvT8kNhh2PWBGB9zU=";
  };

  propagatedBuildInputs = with python3Packages; [
    notmuch2
    google-api-python-client
    google-auth-oauthlib
    tqdm
    setuptools
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
    maintainers = with maintainers; [ archer-65 flokli ];
    mainProgram = "gmi";
  };
}
