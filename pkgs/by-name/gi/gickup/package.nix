{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule rec {
  pname = "gickup";
  version = "0.10.34";

  src = fetchFromGitHub {
    owner = "cooperspencer";
    repo = "gickup";
    rev = "refs/tags/v${version}";
    hash = "sha256-cdYQU5pQj+vypFtvPxN1Vg4ckui+vcYUmOJQ9d3XTK4=";
  };

  vendorHash = "sha256-x+K3qXV0F4OKsldsnNcR5w4fmwYyt7V7IDrcHBNPttI=";

  ldflags = [ "-X main.version=${version}" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tool to backup repositories";
    homepage = "https://github.com/cooperspencer/gickup";
    changelog = "https://github.com/cooperspencer/gickup/releases/tag/v${version}";
    maintainers = with lib.maintainers; [ adamcstephens ];
    mainProgram = "gickup";
    license = lib.licenses.asl20;
  };
}
