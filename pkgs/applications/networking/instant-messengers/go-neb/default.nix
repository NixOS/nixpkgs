{ lib, buildGoModule, fetchFromGitHub, nixosTests, olm }:

buildGoModule {
  pname = "go-neb";
  version = "unstable-2021-03-24";
  src = fetchFromGitHub {
    owner = "matrix-org";
    repo = "go-neb";
    rev = "b6edd50d6e33de3bcdb35055fa6c5f0157f45321";
    sha256 = "sha256-wFqkN4C0rWzWxa6+/LiHMMS8i/g3Q57f5z4cG2XZQzs=";
  };

  subPackages = [ "." ];

  buildInputs = [ olm ];

  vendorSha256 = "sha256-sWrLWjODf25Z8QqCDg4KyVWmTc3PRiYpRL88yxK0j/M";

  doCheck = false;

  passthru.tests.go-neb = nixosTests.go-neb;

  meta = with lib; {
    description = "Extensible matrix bot written in Go";
    homepage = "https://github.com/matrix-org/go-neb";
    license = licenses.asl20;
    maintainers = with maintainers; [ hexa maralorn ];
  };
}
