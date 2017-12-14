{ stdenv, fetchFromGitHub, python3Packages }:

python3Packages.buildPythonApplication rec {
  name = "gmailieer";
  version = "0.5";

  src = fetchFromGitHub {
    owner = "gauteh";
    repo = "gmailieer";
    rev = "v${version}";
    sha256 = "152ky06k1wc3jffb48c6zh7c7pr732m9f4g1i316zaa4nx2ynfsa";
  };

  propagatedBuildInputs = with python3Packages; [
    notmuch
    oauth2client
    google_api_python_client
    tqdm
  ];

  meta = with stdenv.lib; {
    description      = "Fast email-fetching and two-way tag synchronization between notmuch and GMail";
    longDescription  = ''
      This program can pull email and labels (and changes to labels)
      from your GMail account and store them locally in a maildir with
      the labels synchronized with a notmuch database. The changes to
      tags in the notmuch database may be pushed back remotely to your
      GMail account.
    '';
    homepage         = https://github.com/gauteh/gmailieer;
    repositories.git = https://github.com/gauteh/gmailieer.git;
    license          = licenses.gpl3Plus;
    maintainers      = with maintainers; [ kaiha ];
  };
}
