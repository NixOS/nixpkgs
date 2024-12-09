{ lib, stdenvNoCC, fetchFromGitHub, bash, scdoc }:

stdenvNoCC.mkDerivation rec {
  pname = "fetchutils";
  version = "unstable-2021-03-16";

  src = fetchFromGitHub {
    owner = "kiedtl";
    repo = pname;
    rev = "882781a297e86f4ad4eaf143e0777fb3e7c69526";
    sha256 = "sha256-ONrVZC6GBV5v3TeBekW9ybZjDHF3FNyXw1rYknqKRbk=";
  };

  buildInputs = [ bash scdoc ];

  installFlags = [ "PREFIX=$(out)/" ];

  postPatch = ''
    patchShebangs --host src/*
  '';

  meta = with lib; {
    description = "Collection of small shell utilities to fetch system information";
    homepage = "https://github.com/lptstr/fetchutils";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ moni ];
  };
}
