{ stdenv, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "lieer";
  version = "1.2";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "1cz0zi85sm3ffbrfn3nap3ad9krfwb1a9apfn0cb6fp2w0kcqrda";
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
    maintainers      = with maintainers; [ flokli kaiha ];
  };
}
