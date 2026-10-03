{
  lib,
  perlPackages,
  fetchFromGitHub,
}:

perlPackages.buildPerlPackage rec {
  pname = "pgtop";
  version = "0.11";

  src = fetchFromGitHub {
    owner = "cosimo";
    repo = "pgtop";
    rev = "v${version}";
    hash = "sha256-1JhONErzpkBDHdJ7am/0rEQdcglf+JJdOxVG15qhnqs=";
  };

  outputs = [ "out" ];

  buildInputs = with perlPackages; [
    DBI
    DBDPg
    TermReadKey
    JSON
    LWP
  ];

  meta = {
    description = "PostgreSQL clone of `mytop', which in turn is a `top' clone for MySQL";
    mainProgram = "pgtop";
    homepage = "https://github.com/cosimo/pgtop";
    changelog = "https://github.com/cosimo/pgtop/releases/tag/v${version}";
    maintainers = [ lib.maintainers.hagl ];
    license = lib.licenses.gpl2Only;
  };
}
