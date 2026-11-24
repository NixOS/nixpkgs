{
  lib,
  stdenv,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule (finalAttrs: {
  version = "3.1.750";
  pname = "ipsw";

  src = fetchFromGitHub {
    owner = "blacktop";
    repo = "ipsw";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vvq4miTpY0EajPm/bGCx86fvQPtXqZmQRsghhP2WuA8=";
  };

  # Files behind the `sandbox` build tag import the closed-source pkg/sandbox,
  # which is not in the repository. `go mod vendor` resolves the imports of
  # every build tag and fails; `go mod download` does not.
  proxyVendor = true;
  vendorHash = "sha256-vN+MhVKYCfXf5FG+MALd5EQ9prVgMzSEEzcnw1UeZsM=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/blacktop/ipsw/cmd/ipsw/cmd.AppVersion=${finalAttrs.version}"
    "-X github.com/blacktop/ipsw/cmd/ipsw/cmd.AppBuildCommit=${finalAttrs.src.tag}"
  ];

  subPackages = [
    "cmd/ipsw"
  ];

  meta = {
    description = "iOS/macOS Research Swiss Army Knife";
    homepage = "https://blacktop.github.io/ipsw";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.viraptor ];
    platforms = lib.platforms.unix;
    mainProgram = "ipsw";
  };
})
