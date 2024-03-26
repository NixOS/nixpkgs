{ IOKit
, buildGoModule
, fetchFromGitHub
, fetchpatch
, lib
, stdenv
}:

buildGoModule rec {
  pname = "avalanchego";
  version = "1.11.2";

  src = fetchFromGitHub {
    owner = "ava-labs";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-E75lqQkaCub/WpxvVHB5YP1E1ygjUURJ1VWrjvcV96o=";
  };

  vendorHash = "sha256-Xrr4QE0FN6sII4xOjPbhwBlNgEwOlogKRNStjrjH7H0=";
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
    maintainers = with maintainers; [ urandom qjoly ];
    mainProgram = "avalanchego";
  };
}
