{
  lib,
  stdenv,
  fetchFromGitHub,
  buildGoModule,
  testers,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "podman-tui";
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = "containers";
    repo = "podman-tui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vE2GG7lDGORTuziNSoKJWNKGhskcGuEh6U2KHrGu0JQ=";
  };

  vendorHash = null;

  env.CGO_ENABLED = 0;

  tags = [
    "containers_image_openpgp"
    "remote"
  ]
  ++ lib.optional stdenv.hostPlatform.isDarwin "darwin";

  ldflags = [
    "-s"
    "-w"
  ];

  checkFlags =
    let
      skippedTests = [
        # Disable flaky tests
        "TestDialogs"
        "TestVoldialogs"
      ];
    in
    [ "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$" ];

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
    command = "HOME=$(mktemp -d) podman-tui version";
    version = "v${finalAttrs.version}";
  };

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/containers/podman-tui";
    description = "Podman Terminal UI";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      aaronjheng
      iedame
    ];
    mainProgram = "podman-tui";
  };
})
