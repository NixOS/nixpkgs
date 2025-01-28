{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule rec {
  pname = "pebble";
  version = "2.7.0";

  src = fetchFromGitHub {
    owner = "letsencrypt";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-rrDhFvXm85+yAVK9gQXCxpZ9hxvq/W9YzGw/meFJ8T8=";
  };

  vendorHash = null;

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  passthru.tests = {
    smoke-test = nixosTests.acme;
  };

  meta = {
    homepage = "https://github.com/letsencrypt/pebble";
    description = "Small RFC 8555 ACME test server";
    longDescription = "Miniature version of Boulder, Pebble is a small RFC 8555 ACME test server not suited for a production CA";
    license = [ lib.licenses.mpl20 ];
    mainProgram = "pebble";
    maintainers = lib.teams.acme.members;
  };
}
