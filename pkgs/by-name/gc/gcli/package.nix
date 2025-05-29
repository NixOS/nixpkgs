{
  lib,
  fetchFromGitHub,
  stdenv,
  curl,
  pkg-config,
  byacc,
  flex,
  fetchpatch,
}:

stdenv.mkDerivation rec {
  pname = "gcli";
  version = "2.7.0";

  src = fetchFromGitHub {
    owner = "herrhotzenplotz";
    repo = "gcli";
    rev = "v${version}";
    hash = "sha256-N5dzGhyXPDWcm/cNUSUQt4rR+PzaD1OUssRO3Sdfmoo=";
  };

  patches = [
    # Darwin builds are fixed in master, but the change is unreleased.
    (fetchpatch {
      name = "darwin-build-fix.patch";
      url = "https://github.com/herrhotzenplotz/gcli/commit/720e372250fd363bdd90e9452907508563e30f93.patch";
      hash = "sha256-TpjIisje20YObN2wf8iQlwHlY5kg0S7xTkUWxAmK+po=";
    })
  ];

  nativeBuildInputs = [
    pkg-config
    byacc
    flex
  ];
  buildInputs = [ curl ];

  meta = with lib; {
    description = "Portable Git(Hub|Lab|ea) CLI tool";
    homepage = "https://herrhotzenplotz.de/gcli/";
    changelog = "https://github.com/herrhotzenplotz/gcli/releases/tag/${version}";
    license = licenses.bsd2;
    mainProgram = "gcli";
    maintainers = with maintainers; [ kenran ];
    platforms = platforms.unix;
  };
}
