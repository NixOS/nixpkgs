{ IOKit
, buildGoModule
, fetchFromGitHub
, lib
, stdenv
}:

buildGoModule rec {
  pname = "avalanchego";
  version = "1.11.10";

  src = fetchFromGitHub {
    owner = "ava-labs";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-O+94hdRaPZYcU4ICiGGQ7CBKPMAT9qPCsMsHcurW+/4=";
  };

  vendorHash = "sha256-jXtnPBlSeA1Q+2VY+It7XnORz6uW0ZLYX+csBTYolNE=";
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
