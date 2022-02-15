{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "k0sctl";
  version = "0.11.4";

  src = fetchFromGitHub {
    owner = "k0sproject";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Fk1aYSa3LqzxiHtlzH5pcNtodOprjfnCFh4UMqCa6Rc=";
  };

  vendorSha256 = "sha256-21C6wZ8lKQnbUg3aD0ZFVOgopblXyWk4WP/ubZVk3Yk=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/k0sproject/k0sctl/version.Environment=production"
    "-X github.com/k0sproject/k0sctl/version.Version=${version}"
  ];

  meta = with lib; {
    description = "A bootstrapping and management tool for k0s clusters.";
    homepage = "https://k0sproject.io/";
    license = licenses.asl20;
    maintainers = with maintainers; [ nickcao ];
  };
}
