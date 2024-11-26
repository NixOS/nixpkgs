{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "dnadd";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "JoeLancaster";
    repo = pname;
    rev = "v${version}";
    sha256 = "1vzbgz8y9gj4lszsx4iczfbrj373sl4wi43j7rp46zfcbw323d4r";
  };

  strictDeps = true;
  makeFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    homepage = "https://github.com/joelancaster/dnadd";
    description = "Adds packages declaratively on the command line";
    mainProgram = "dnadd";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ joelancaster ];
  };
}
