{
  IOKit,
  buildGoModule,
  fetchFromGitHub,
  lib,
  stdenv,
}:

buildGoModule rec {
  pname = "avalanchego";
  version = "1.11.5";

  src = fetchFromGitHub {
    owner = "ava-labs";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-IZ4Q67b+VsmBN/NEBPDzN2PYO8cVfLpHBU0tCo+v3Xc=";
  };

  vendorHash = "sha256-z6MF/Kb///BSirdRycNs+7SMThv+yS7WmcrIcgiwBNg=";
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
    maintainers = with maintainers; [
      urandom
      qjoly
    ];
    mainProgram = "avalanchego";
  };
}
