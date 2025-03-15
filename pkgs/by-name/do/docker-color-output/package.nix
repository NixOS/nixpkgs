{
  lib,
  fetchFromGitHub,
  buildGoModule,
  nix-update-script,
}:

buildGoModule rec {
  pname = "docker-color-output";
  version = "2.5.1";

  src = fetchFromGitHub {
    owner = "devemio";
    repo = "docker-color-output";
    tag = version;
    hash = "sha256-rnCZ+6t6iOiLBynp1EPshO+/otAdtu8yy1FqFkYB07w=";
  };

  vendorHash = null;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Add color to the Docker CLI";
    mainProgram = "docker-color-output";
    license = lib.licenses.mit;
    homepage = "https://github.com/devemio/docker-color-output";
    changelog = "https://github.com/devemio/docker-color-output/releases/tag/${version}";
    maintainers = with lib.maintainers; [ sguimmara ];
  };
}
