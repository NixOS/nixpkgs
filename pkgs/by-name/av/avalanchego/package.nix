{
  buildGoModule,
  fetchFromGitHub,
  lib,
  nix-update-script,
  stdenv,
}:

buildGoModule rec {
  pname = "avalanchego";
  version = "1.12.0";

  src = fetchFromGitHub {
    owner = "ava-labs";
    repo = "avalanchego";
    rev = "refs/tags/v${version}";
    hash = "sha256-iedhLVNtwU8wSQIaq0r0fAYGH8fNnCRJW69D7wPdyx0=";
  };

  # https://github.com/golang/go/issues/57529
  proxyVendor = true;

  vendorHash = "sha256-CNwqpRx0HNvYfkowEEZe/Ue6W2FDZVAkUgof5QH9XkI=";


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
