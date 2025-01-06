{
  buildGoModule,
  fetchFromGitHub,
  lib,
  nix-update-script,
  stdenv,
}:

buildGoModule rec {
  pname = "avalanchego";
  version = "1.12.1";

  src = fetchFromGitHub {
    owner = "ava-labs";
    repo = "avalanchego";
    tag = "v${version}";
    hash = "sha256-elbY0KNsOmKSTX61nps2tjIFTJH5Nnqmwq6mWwd88aE=";
  };

  # https://github.com/golang/go/issues/57529
  proxyVendor = true;

  vendorHash = "sha256-HRhgnf6vHBrJTHspH+HwR3g5o63i+dCm7kPuBKdSV8s=";


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
