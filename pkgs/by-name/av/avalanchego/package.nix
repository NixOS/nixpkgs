{
  buildGo123Module,
  fetchFromGitHub,
  lib,
  nix-update-script,
}:

buildGo123Module (finalAttrs: {
  pname = "avalanchego";
  version = "1.13.0";

  src = fetchFromGitHub {
    owner = "ava-labs";
    repo = "avalanchego";
    tag = "v${finalAttrs.version}";
    hash = "sha256-t6KruPHt51wJ4aJaCG/8tuwKYtaifHvQ3z9oVknNS4E=";
  };

  # https://github.com/golang/go/issues/57529
  proxyVendor = true;

  vendorHash = "sha256-iyx9k8mPPOwpHo9lEdNPf0sQHxbKbNTVLUZrPYY8dWM=";

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
