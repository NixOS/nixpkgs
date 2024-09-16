{ lib
, buildGoModule
, fetchFromGitHub
, nixosTests
}:

buildGoModule rec {
  pname = "legit";
  version = "0.2.3";

  src = fetchFromGitHub {
    repo = "legit";
    owner = "icyphox";
    rev = "v${version}";
    hash = "sha256-C6PzZFYGjQs1BbYuEwcTpLQ3bNVb1rXTd0zXosF1kaE=";
  };

  vendorHash = "sha256-G4Wij0UCiXyVtb+66yU3FY2WbpPfqo0SA7OOcywnKU0=";

  postInstall = ''
    mkdir -p $out/lib/legit/templates
    mkdir -p $out/lib/legit/static

    cp -r $src/templates/* $out/lib/legit/templates
    cp -r $src/static/* $out/lib/legit/static
  '';

  passthru.tests = { inherit (nixosTests) legit; };

  meta = {
    description = "Web frontend for git";
    homepage = "https://github.com/icyphox/legit";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.ratsclub ];
    mainProgram = "legit";
  };
}
