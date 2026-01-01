{
  lib,
  fetchFromGitHub,
  buildGoModule,
  nixosTests,
}:

buildGoModule rec {
  pname = "lego";
<<<<<<< HEAD
  version = "4.29.0";
=======
  version = "4.27.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "go-acme";
    repo = "lego";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-czCOrgC3Xy42KigAe+tsPRdWqxgdHFl0KN3Ei2zeyy8=";
  };

  vendorHash = "sha256-OnCtobizqDrqZTQenRPBTlUHvNx/xX34PYw8K4rgxSk=";
=======
    hash = "sha256-mc/aWjYvgF5PSl6Ng9oLNWAlGDjnhzEouo9LXh/PFsE=";
  };

  vendorHash = "sha256-648FrZqSatEYONzj03x8z8pV0WIvfYnIOcxERxYxSPw=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  doCheck = false;

  subPackages = [ "cmd/lego" ];

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

<<<<<<< HEAD
  meta = {
    description = "Let's Encrypt client and ACME library written in Go";
    license = lib.licenses.mit;
    homepage = "https://go-acme.github.io/lego/";
    teams = [ lib.teams.acme ];
=======
  meta = with lib; {
    description = "Let's Encrypt client and ACME library written in Go";
    license = licenses.mit;
    homepage = "https://go-acme.github.io/lego/";
    teams = [ teams.acme ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "lego";
  };

  passthru.tests = {
    lego-http = nixosTests.acme.http01-builtin;
    lego-dns = nixosTests.acme.dns01;
  };
}
