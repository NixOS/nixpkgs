{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule rec {
  pname = "pkgsite";
  version = "0-unstable-2024-12-06";

  src = fetchFromGitHub {
    owner = "golang";
    repo = "pkgsite";
    rev = "37884bfc1a9e2aa46989ac56e671bcbd240bb4f7";
    hash = "sha256-RZTRfB1mEM13x/vLrxu7877C7Zh/kJxpYMP9xR2OOXw=";
  };

  vendorHash = "sha256-Ijcj1Nq4WjXcUqmoDkpO9I4rl/4/TMXFMQVAlEK11R8=";

  subPackages = [ "cmd/pkgsite" ];

  ldflags = [ "-s" ];

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Official tool to extract and generate documentation for Go projects like pkg.go.dev";
    homepage = "https://github.com/golang/pkgsite";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ phanirithvij ];
    mainProgram = "pkgsite";
  };
}
