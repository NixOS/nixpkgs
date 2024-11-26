{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule rec {
  pname = "pkgsite";
  version = "0-unstable-2024-12-09";

  src = fetchFromGitHub {
    owner = "golang";
    repo = "pkgsite";
    rev = "73fd41ea89d263e617d2539ba9e73a4f46becfa5";
    hash = "sha256-dxtfQKzUOqAY3DIJwUNPcNcXSe5+nvfk4QtJsw/Vchc=";
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
