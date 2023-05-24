{ IOKit
, buildGoModule
, fetchFromGitHub
, fetchpatch
, lib
, stdenv
}:

buildGoModule rec {
  pname = "avalanchego";
  version = "1.10.1";

  src = fetchFromGitHub {
    owner = "ava-labs";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-KGHghhHALMoFuO7i4wq9B2HA2WTA80WSOR5Odpo1Ing=";
  };

  vendorHash = "sha256-+YzC7xjrRI0e8/cOcJM3AZS5hI82H1qFxnfUGMgqXhs=";
  # go mod vendor has a bug, see: https://github.com/golang/go/issues/57529
  proxyVendor = true;

  buildInputs = lib.optionals stdenv.isDarwin [ IOKit ];

  subPackages = [ "main" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/ava-labs/avalanchego/version.GitCommit=${version}"
  ];

  postInstall = ''
    mv $out/bin/{main,${pname}}
  '';

  meta = with lib; {
    description = "Go implementation of an Avalanche node";
    homepage = "https://github.com/ava-labs/avalanchego";
    changelog = "https://github.com/ava-labs/avalanchego/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ urandom ];
  };
}
