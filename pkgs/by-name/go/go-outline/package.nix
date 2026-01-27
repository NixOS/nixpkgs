{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "go-outline";
  version = "unstable-2021-06-08";

  src = fetchFromGitHub {
    owner = "ramya-rao-a";
    repo = "go-outline";
    rev = "9736a4bde949f321d201e5eaa5ae2bcde011bf00";
    hash = "sha256-5ns6n1UO9kRSw8iio4dmJDncsyvFeN01bjxHxQ9Fae4=";
  };

  vendorHash = "sha256-jYYtSXdJd2eUc80UfwRRMPcX6tFiXE3LbxV3NAdKVKE=";

  ldflags = [
    "-s"
    "-w"
  ];

  # go-outline doesn't support --version
  doInstallCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Utility to extract JSON representation of declarations from a Go source file";
    mainProgram = "go-outline";
    homepage = "https://github.com/ramya-rao-a/go-outline";
    changelog = "https://github.com/ramya-rao-a/go-outline/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    maintainers = with lib.maintainers; [ vdemeester ];
    license = lib.licenses.mit;
  };
})
