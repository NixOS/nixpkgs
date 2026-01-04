{
  lib,
  fetchFromGitHub,
  buildGoModule,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule rec {
  pname = "bento";
  version = "1.13.1";

  src = fetchFromGitHub {
    owner = "warpstreamlabs";
    repo = "bento";
    tag = "v${version}";
    hash = "sha256-5UzicbR+JzLgPLilPHO9HKteC632cJc5EQanPPc0lj8=";
  };

  proxyVendor = true;
  vendorHash = "sha256-wZPhjzDD2T7CYz0Y0QkFarnTOsJzm5snlp9KnBuOc3U=";

  subPackages = [
    "cmd/bento"
    "cmd/serverless/bento-lambda"
  ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/warpstreamlabs/bento/internal/cli.Version=${version}"
    "-X main.Version=${version}"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "High performance and resilient stream processor";
    homepage = "https://warpstreamlabs.github.io/bento/";
    changelog = "https://github.com/warpstreamlabs/bento/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ genga898 ];
    mainProgram = "bento";
  };
}
