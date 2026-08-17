{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule {
  pname = "pkgsite";
  version = "0.2.0-unstable-2026-07-07";

  src = fetchFromGitHub {
    owner = "golang";
    repo = "pkgsite";
    rev = "0cc61a18508245cabd093f065961abd5df0af028";
    hash = "sha256-tgLjEs9dt7TA9yRq/toUWPiorA4b20GnjmO6HJbFFd8=";
  };

  vendorHash = "sha256-a53JKkoJmnSO+ShxUt68LEq9uDeNi/vN/d0OuhrIUvA=";

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
