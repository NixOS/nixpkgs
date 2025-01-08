{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule rec {
  pname = "pkgsite";
  version = "0-unstable-2024-12-26";

  src = fetchFromGitHub {
    owner = "golang";
    repo = "pkgsite";
    rev = "8bad909da0cbaf239510644c5a91d1be27376d9f";
    hash = "sha256-EsShGqT2Pk8VdxNRplliPb5+VoD05/sQzGNTsk0VZEI=";
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
