{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule (finalAttrs: {
  pname = "pebble";
  version = "2.10.0";

  src = fetchFromGitHub {
    owner = "letsencrypt";
    repo = "pebble";
    rev = "v${finalAttrs.version}";
    hash = "sha256-EMZ7grJU6dM+1o5NLPxDX/Yix8SOXHpGzNUULEYvREA=";
  };

  vendorHash = null;

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  passthru.tests = {
    smoke-test-http = nixosTests.acme.http01-builtin;
    smoke-test-dns = nixosTests.acme.dns01;
  };

  meta = {
    homepage = "https://github.com/letsencrypt/pebble";
    description = "Small RFC 8555 ACME test server";
    longDescription = "Miniature version of Boulder, Pebble is a small RFC 8555 ACME test server not suited for a production CA";
    license = [ lib.licenses.mpl20 ];
    mainProgram = "pebble";
    teams = [ lib.teams.acme ];
  };
})
