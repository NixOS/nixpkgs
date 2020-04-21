{ stdenv, fetchFromGitHub, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "lieer";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "gauteh";
    repo = "lieer";
    rev = "v${version}";
    sha256 = "19jx3sm925nrzl26km1bxbp6y5gk1mzwadd79vip2jl70b3xk9f8";
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
    homepage         = "https://lieer.gaute.vetsj.com/";
    repositories.git = "https://github.com/gauteh/lieer.git";
    license          = licenses.gpl3Plus;
    maintainers      = with maintainers; [ kaiha ];
  };
}
