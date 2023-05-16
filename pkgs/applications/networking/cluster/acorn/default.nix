{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "acorn";
<<<<<<< HEAD
  version = "0.8.0";
=======
  version = "0.6.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "acorn-io";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-ZS3YxXgMSu8+eRnpqrtaBTQIlSY3cscudcTbztiRsbM=";
  };

  vendorHash = "sha256-jkkzlMc2y8HvPZjpmRIQz64JK5yjhdoJevE0dclBHvA=";
=======
    hash = "sha256-X4EXF6t6RzjHCbo2+oB69sFoqeRc5blSmB7x1iQCYIA=";
  };

  vendorHash = "sha256-cx+7vbVpoeNwE4mNaQKuguALObyCrEA7EQPdnJ0H9mM=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  ldflags = [
    "-s"
    "-w"
    "-X github.com/acorn-io/acorn/pkg/version.Tag=v${version}"
<<<<<<< HEAD
=======
    "-X github.com/acorn-io/acorn/pkg/config.AcornDNSEndpointDefault=https://alpha-dns.acrn.io/v1"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  # integration tests require network and kubernetes master
  doCheck = false;

  meta = with lib; {
    homepage = "https://docs.acorn.io";
    changelog = "https://github.com/acorn-io/${pname}/releases/tag/v${version}";
    description = "A simple application deployment framework for Kubernetes";
    license = licenses.asl20;
    maintainers = with maintainers; [ urandom ];
  };
}
