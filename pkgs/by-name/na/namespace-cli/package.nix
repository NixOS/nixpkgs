{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule rec {
  pname = "namespace-cli";
  version = "0.0.428";

  src = fetchFromGitHub {
    owner = "namespacelabs";
    repo = "foundation";
    rev = "v${version}";
    hash = "sha256-W2IUEr7jN6GN03Gm7dJY8hl558eaMNdp0j33i+d8Qqs=";
  };

  vendorHash = "sha256-5cZy89dJbekxba7BTxKtJkicRPUsl4PyLiNZnG564U4=";

  subPackages = [
    "cmd/nsc"
    "cmd/ns"
    "cmd/docker-credential-nsc"
  ];

  ldflags = [
    "-s"
    "-w"
    "-X namespacelabs.dev/foundation/internal/cli/version.Tag=v${version}"
  ];

  meta = {
    mainProgram = "nsc";
    maintainers = with lib.maintainers; [ techknowlogick ];
    license = lib.licenses.asl20;
    changelog = "https://github.com/namespacelabs/foundation/releases/tag/v${version}";
    homepage = "https://github.com/namespacelabs/foundation";
    description = "Command line interface for the Namespaces platform";
  };
}
