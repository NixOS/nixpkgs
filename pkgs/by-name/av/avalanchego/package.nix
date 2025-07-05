{
  buildGo123Module,
  fetchFromGitHub,
  lib,
  nix-update-script,
}:

buildGo123Module (finalAttrs: {
  pname = "avalanchego";
  version = "1.13.1";

  src = fetchFromGitHub {
    owner = "ava-labs";
    repo = "avalanchego";
    tag = "v${finalAttrs.version}";
    hash = "sha256-AyYBPkMPwgbxgr5Q/mpAUpsXhQ9Y++91XkPHScZ1MtI=";
  };

  # https://github.com/golang/go/issues/57529
  proxyVendor = true;

  vendorHash = "sha256-pMrkXv9vgED6e1qtgz+pJj3T0Nyemy0PKr8w7ZiKbgk=";

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
