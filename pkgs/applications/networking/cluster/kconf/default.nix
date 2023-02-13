{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kconf";
  version = "1.12.0";

  src = fetchFromGitHub {
    owner = "particledecay";
    repo = "kconf";
    rev = "v${version}";
    sha256 = "sha256-aEZTwXccKZDXRNWr4XS2ZpqtEnNGbsIVau8zPvaHTkk=";
  };

  vendorSha256 = "sha256-7mzk2OP1p8FfRsbs4B6XP/szBeckm7Q7hf8AkbZUG2Q=";

  ldflags = [
      "-s" "-w" "-X github.com/particledecay/kconf/build.Version=${version}"
  ];

  meta = with lib; {
    description = "An opinionated command line tool for managing multiple kubeconfigs";
    homepage = "https://github.com/particledecay/kconf";
    license = licenses.mit;
    maintainers = with maintainers; [ thmzlt ];
  };
}
