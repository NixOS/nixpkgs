{ IOKit
, buildGoModule
, fetchFromGitHub
, lib
, stdenv
}:

buildGoModule rec {
  pname = "avalanchego";
  version = "1.11.11";

  src = fetchFromGitHub {
    owner = "ava-labs";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-9NhwxB5AeGvQgZbjNu5WWHiP194ws7s1WDtCntLr//g=";
  };

  vendorHash = "sha256-A8Bf/KzTFvC/hFLU1k6M89649wjoqnIXRQ1uJaTj9YA=";
  # go mod vendor has a bug, see: https://github.com/golang/go/issues/57529
  proxyVendor = true;

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ IOKit ];

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
