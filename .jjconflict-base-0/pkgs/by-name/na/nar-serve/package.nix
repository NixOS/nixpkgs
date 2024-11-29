{ buildGoModule
, fetchFromGitHub
, lib
, nixosTests
}:
buildGoModule rec {
  pname = "nar-serve";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "numtide";
    repo = "nar-serve";
    rev = "v${version}";
    hash = "sha256-8QuMS00EutmqzAIPxyJEPxM8EHiWlSKs6E2Htoh3Kes=";
  };

  vendorHash = "sha256-td9NYHGYJYPlIj2tnf5I/GnJQOOgODc6TakHFwxyvLQ=";

  doCheck = false;

  passthru.tests = { inherit (nixosTests) nar-serve; };

  meta = with lib; {
    description = "Serve NAR file contents via HTTP";
    mainProgram = "nar-serve";
    homepage = "https://github.com/numtide/nar-serve";
    license = licenses.mit;
    maintainers = with maintainers; [ rizary zimbatm ];
  };
}
