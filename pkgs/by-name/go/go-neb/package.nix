{ lib, stdenv, buildGoModule, fetchFromGitHub, nixosTests, olm }:

buildGoModule {
  pname = "go-neb";
  version = "unstable-2021-07-21";
  src = fetchFromGitHub {
    owner = "matrix-org";
    repo = "go-neb";
    rev = "8916c80f8ce1732f64b50f9251242ca189082e76";
    sha256 = "sha256-kuH4vbvS4G1bczxUdY4bd4oL4pIZzuueUxdEp4xuzJM=";
  };

  subPackages = [ "." ];

  buildInputs = [ olm ];

  vendorHash = "sha256-5Vg7aUkqiFIQuxmsDOJjvXoeA5NjMoBoD0XBhC+o4GA=";

  doCheck = false;

  passthru.tests.go-neb = nixosTests.go-neb;

  meta = with lib; {
    broken = stdenv.hostPlatform.isDarwin;
    description = "Extensible matrix bot written in Go";
    mainProgram = "go-neb";
    homepage = "https://github.com/matrix-org/go-neb";
    license = licenses.asl20;
    maintainers = with maintainers; [ hexa maralorn ];
  };
}
