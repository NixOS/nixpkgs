<<<<<<< HEAD
{ lib
, fetchFromGitHub
, python3Packages
}:

python3Packages.buildPythonApplication rec {
  pname = "lieer";
  version = "1.4";
  format = "setuptools";
=======
{ lib, fetchFromGitHub, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "lieer";
  version = "1.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "gauteh";
    repo = "lieer";
<<<<<<< HEAD
    rev = "refs/tags/v${version}";
    sha256 = "sha256-2LujfvsxMHHmYjYOnLJaLdSlzDeej+ehUr4YfVe903U=";
  };

  propagatedBuildInputs = with python3Packages; [
    notmuch2
=======
    rev = "v${version}";
    sha256 = "12sl7d381l1gjaam419xc8gxmsprxf0hgksz1f974qmmijvr02bh";
  };

  propagatedBuildInputs = with python3Packages; [
    notmuch
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    oauth2client
    google-api-python-client
    tqdm
    setuptools
  ];

  # no tests
  doCheck = false;
<<<<<<< HEAD

  pythonImportsCheck = [
    "lieer"
  ];
=======
  pythonImportsCheck = [ "lieer" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
  };
}
