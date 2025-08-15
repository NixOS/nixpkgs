{
  lib,
  fetchFromGitHub,
  buildGoModule,
  nixosTests,
}:

buildGoModule rec {
  pname = "lego";
  version = "4.25.2";

  src = fetchFromGitHub {
    owner = "go-acme";
    repo = "lego";
    tag = "v${version}";
    hash = "sha256-VAYptzJYyo6o5MPq0DB8+VrhqzwJSPwZK6BuaXOn8VM=";
  };

  vendorHash = "sha256-8135PtcC98XxbdQnF58sglAgZUkuBA+A3bSxK0+tQ9U=";

  doCheck = false;

  subPackages = [ "cmd/lego" ];

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  meta = with lib; {
    description = "Let's Encrypt client and ACME library written in Go";
    license = licenses.mit;
    homepage = "https://go-acme.github.io/lego/";
    teams = [ teams.acme ];
    mainProgram = "lego";
  };

  passthru.tests = {
    lego-http = nixosTests.acme.http01-builtin;
    lego-dns = nixosTests.acme.dns01;
  };
}
