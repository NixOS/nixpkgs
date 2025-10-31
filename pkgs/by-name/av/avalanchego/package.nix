{
  buildGoModule,
  fetchFromGitHub,
  lib,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "avalanchego";
  version = "1.14.0-fuji";

  src = fetchFromGitHub {
    owner = "ava-labs";
    repo = "avalanchego";
    tag = "v${finalAttrs.version}";
    hash = "sha256-N2QYoFj49t/te0UDy/iAKNqWmf91nmE5pjhlanI2r2E=";
  };

  # https://github.com/golang/go/issues/57529
  proxyVendor = true;

  vendorHash = "sha256-5qJoT4xdfzpPmbXBfhysDxojc5XbbiBGLMpnC7mGmS4=";

  subPackages = [ "main" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/ava-labs/avalanchego/version.GitCommit=${finalAttrs.version}"
  ];

  postInstall = ''
    mv $out/bin/{main,avalanchego}
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Go implementation of an Avalanche node";
    homepage = "https://github.com/ava-labs/avalanchego";
    changelog = "https://github.com/ava-labs/avalanchego/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      urandom
      qjoly
    ];
    mainProgram = "avalanchego";
  };
})
