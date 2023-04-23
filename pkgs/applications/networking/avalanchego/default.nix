{ IOKit
, buildGoModule
, fetchFromGitHub
, fetchpatch
, lib
, stdenv
}:

buildGoModule rec {
  pname = "avalanchego";
  version = "1.10.0";

  src = fetchFromGitHub {
    owner = "ava-labs";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-OQh8xub/4DHZk4sGIJldyoXGR/TQ9F0reERk2lpjYi8=";
  };

  vendorHash = "sha256-etvCtNCW6tuzKZEEx2RODzMx0W9hGoXNS2jWGJO+Pc0=";
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
