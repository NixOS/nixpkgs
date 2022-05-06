{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kconf";
  version = "1.11.0";

  src = fetchFromGitHub {
    owner = "particledecay";
    repo = "kconf";
    rev = "v${version}";
    sha256 = "sha256-V+B1vqI/MLASqEy6DZiB71h7EkUfrxVKIMxriRK6pyY=";
  };

  vendorSha256 = "sha256-Fq3V3vYaofB0TWt3t7uW1Dd7MlwMvh8RaRVpdq9XZh4=";

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
