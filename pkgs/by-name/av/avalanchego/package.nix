{
  buildGoModule,
  fetchFromGitHub,
  lib,
  nix-update-script,
  stdenv,
}:

buildGoModule rec {
  pname = "avalanchego";
  version = "1.12.3-warp-verify6";

  src = fetchFromGitHub {
    owner = "ava-labs";
    repo = "avalanchego";
    tag = "v${version}";
    hash = "sha256-1d5spKJA99Hyj7nW5BrhrA5x4QTeIYdXTyzGkj/a07w=";
  };

  # https://github.com/golang/go/issues/57529
  proxyVendor = true;

  vendorHash = "sha256-c9FRX+BNj1meM3llt834U2xuD7SytoRqGeVyXa1cjxw=";


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
