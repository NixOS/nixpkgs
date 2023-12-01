{ lib
, fetchFromGitHub
, python3Packages
}:

python3Packages.buildPythonApplication rec {
  pname = "lieer";
  version = "1.4";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "gauteh";
    repo = "lieer";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-2LujfvsxMHHmYjYOnLJaLdSlzDeej+ehUr4YfVe903U=";
  };

  propagatedBuildInputs = with python3Packages; [
    notmuch2
    oauth2client
    google-api-python-client
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
    maintainers = with maintainers; [ flokli ];
    mainProgram = "gmi";
  };
}
