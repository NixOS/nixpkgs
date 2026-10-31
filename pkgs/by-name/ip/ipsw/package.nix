{
  lib,
  stdenv,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule (finalAttrs: {
  version = "3.1.736";
  pname = "ipsw";

  src = fetchFromGitHub {
    owner = "blacktop";
    repo = "ipsw";
    tag = "v${finalAttrs.version}";
    hash = "sha256-HTPGSycl1HAGqxHZWPwJ5l518/57i0qI5O5NMuvEyxw=";
  };

  # Files behind the `sandbox` build tag import the closed-source pkg/sandbox,
  # which is not in the repository. `go mod vendor` resolves the imports of
  # every build tag and fails; `go mod download` does not.
  proxyVendor = true;
  vendorHash = "sha256-zj9iBRWjYdX2uZ2r9ebe4oUT89hTfO8RICEPK05Vpeo=";

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
