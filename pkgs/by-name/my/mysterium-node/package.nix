{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "mysterium-node";
  version = "1.35.4";

  src = fetchFromGitHub {
    owner = "mysteriumnetwork";
    repo = "node";
    tag = finalAttrs.version;
    hash = "sha256-VVma0cMaBJYRdMF5I6hZ6g3eO1FHY/s/YR3q7YigHoU=";
  };

  vendorHash = "sha256-ep8h0XLxNPBNOL+zVg7hAO+Jzr9UYRARF54enavjyvg=";

  subPackages = [
    "cmd/mysterium_node"
  ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/mysteriumnetwork/node/metadata.Version=${finalAttrs.version}"
    "-X github.com/mysteriumnetwork/node/metadata.BuildNumber=${finalAttrs.version}"
    "-X github.com/mysteriumnetwork/node/metadata.BuildBranch=${finalAttrs.version}"
    "-X github.com/mysteriumnetwork/node/metadata.BuildCommit=${finalAttrs.version}"
  ];

  tags = [
    "netgo"
  ];

  env.CGO_ENABLED = 0;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    install -Dm755 $GOPATH/bin/mysterium_node $out/bin/mysterium-node
    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Official implementation of distributed VPN network (dVPN) protocol";
    homepage = "https://github.com/mysteriumnetwork/node";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      m0ustach3
    ];
    changelog = "https://github.com/mysteriumnetwork/node/releases/tag/${finalAttrs.version}";
    mainProgram = "mysterium-node";
  };
})
