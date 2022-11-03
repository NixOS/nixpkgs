{ lib, buildGoModule, fetchFromGitHub, nixosTests, olm, updateGolangSysHook }:

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

  nativeBuildInputs = [ updateGolangSysHook ];

  buildInputs = [ olm ];

  vendorSha256 = "sha256-TgOiMcUTmeFJ3yB9z5ovPaoys3PdbMIeP8J6+4GThBk=";

  doCheck = false;

  passthru.tests.go-neb = nixosTests.go-neb;

  meta = with lib; {
    description = "Extensible matrix bot written in Go";
    homepage = "https://github.com/matrix-org/go-neb";
    license = licenses.asl20;
    maintainers = with maintainers; [ hexa maralorn ];
  };
}
