{
  lib,
  rustPlatform,
  fetchFromGitHub,
  testers,
  nixel,
}:

rustPlatform.buildRustPackage rec {
  pname = "nixel";
  version = "4.1.0";

  src = fetchFromGitHub {
    owner = "kamadorueda";
    repo = pname;
    rev = version;
    sha256 = "sha256-dQ3wzBTjteqk9rju+FMAO+ydimnGu24Y2DEDLX/P+1A=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-X/O1Lg1llyRz+d5MC1xO4qKU1+mDIlZhgj6qQ9kLH4k=";

  # Package requires a non reproducible submodule
  # https://github.com/kamadorueda/nixel/blob/2873bd84bf4fc540d0ae8af062e109cc9ad40454/.gitmodules#L7
  doCheck = false;
  #
  # Let's test it runs
  passthru.tests = {
    version = testers.testVersion { package = nixel; };
  };

  meta = with lib; {
    description = "Lexer, Parser, Abstract Syntax Tree and Concrete Syntax Tree for the Nix Expressions Language";
    mainProgram = "nixel";
    homepage = "https://github.com/kamadorueda/nixel";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ kamadorueda ];
  };
}
