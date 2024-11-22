{
  buildGoModule,
  fetchFromGitHub,
  lib,
  nix-update-script,
  stdenv,
}:

buildGoModule rec {
  pname = "avalanchego";
  version = "1.12.0-initial-poc.6";

  src = fetchFromGitHub {
    owner = "ava-labs";
    repo = "avalanchego";
    rev = "refs/tags/v${version}";
    hash = "sha256-LBwmoegsBWC2xlTc3BJDxyYX58b+X7g5xl9vnThVHW0=";
  };

  # https://github.com/golang/go/issues/57529
  proxyVendor = true;

  vendorHash = "sha256-slu0f0Y33aGuVpN5pZcRp9RJAXcLnZyUNO7pFdm+HrY=";


  subPackages = [ "main" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/ava-labs/avalanchego/version.GitCommit=${version}"
  ];

  postInstall = ''
    mv $out/bin/{main,${pname}}
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Go implementation of an Avalanche node";
    homepage = "https://github.com/ava-labs/avalanchego";
    changelog = "https://github.com/ava-labs/avalanchego/releases/tag/v${version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      urandom
      qjoly
    ];
    mainProgram = "avalanchego";
  };
}
