{ mkDerivation, haskellPackages, fetchFromGitHub, lib}:

let
  version = "2.1.0";
in

mkDerivation {
  pname = "idid";
  inherit version;

  src = fetchFromGitHub {
    owner = "dbalan";
    repo = "idid";
    rev = "v${version}";
    sha256 = "0hgx8ygj159ymqfyfmbrilhf3fwfm3nsxfdbglkqbj89v14b652m";
  };

  isLibrary = false;
  doCheck = true;

  libraryToolDepends = with haskellPackages; [ hpack ];
  libraryHaskellDepends = with haskellPackages; [ base ];
  executableHaskellDepends = with haskellPackages; [
                           base
                           optparse-applicative
                           time
                           directory
                           filepath
  ];

  preConfigure = "hpack";

  description = "Tool to keep track of things done";
  homepage = "https://github.com/dbalan/idid";
  license = lib.licenses.bsd3;
  maintainers = [ lib.maintainers.dbalan ];
}
