{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule rec {
  pname = "pkgsite";
  version = "0-unstable-2024-12-16";

  src = fetchFromGitHub {
    owner = "golang";
    repo = "pkgsite";
    rev = "06c6edf28e6c1a9f5567f7141512681ba5b75f60";
    hash = "sha256-zsb4NxTxyH354fHtVo8xtFxzOw7XeEnxupfQlh4fAHo=";
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
