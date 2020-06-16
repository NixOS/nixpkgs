{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule {
  pname = "go-neb";
  version = "unstable-2020-04-09";
  src = fetchFromGitHub {
    owner = "matrix-org";
    repo = "go-neb";
    rev = "1e297c50ad2938e511a3c86f4b190fd3fc3559d6";
    sha256 = "1azwy4s4kmypps1fjbz76flpi1b7sjzjj4qwx94cry0hn3qfnrc6";
  };

  subPackages = [ "." ];

  patches = [ ./go-mod.patch ];

  vendorSha256 = "1k3980yf6zl00dkd1djwhm2f9nnffzrsbs3kq3alpw2gm0aln739";

  passthru.tests.go-neb = nixosTests.go-neb;

  meta = with lib; {
    description = "Extensible matrix bot written in Go";
    homepage = "https://github.com/matrix-org/go-neb";
    license = licenses.asl20;
    maintainers = with maintainers; [ hexa maralorn ];
  };
}
