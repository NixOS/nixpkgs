{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  testers,
  callPackage,
  ejson2env,
}:

buildGoModule rec {
  pname = "ejson2env";
  version = "2.0.7";

  src = fetchFromGitHub {
    owner = "Shopify";
    repo = "ejson2env";
    rev = "v${version}";
    sha256 = "sha256-9i84nHIuAR7PG6/v8O5GEi6xToJk0c+knpVPOPx+1b8=";
  };

  vendorHash = "sha256-NirIAwmrUH7ny1H7d63bIrFQ8EWuxjh6Qp66Sw8eMO8=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  passthru = {
    updateScript = nix-update-script { };
    tests = {
      version = testers.testVersion { package = ejson2env; };
      decryption = callPackage ./test-decryption.nix { };
    };
  };

  meta = with lib; {
    description = "Decrypt EJSON secrets and export them as environment variables";
    homepage = "https://github.com/Shopify/ejson2env";
    maintainers = with maintainers; [ viraptor ];
    license = licenses.mit;
    mainProgram = "ejson2env";
  };
}
