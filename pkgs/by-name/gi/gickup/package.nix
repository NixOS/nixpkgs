{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule rec {
  pname = "gickup";
  version = "0.10.39";

  src = fetchFromGitHub {
    owner = "cooperspencer";
    repo = "gickup";
    tag = "v${version}";
    hash = "sha256-Aalt/oiNzV2a8Ix/ruL4r3q0W1EY1UTe9IVPWNL+lLA=";
  };

  vendorHash = "sha256-Xtreh7nHovBYh0PnFYn2VuYGN8GQSmy6EPnZnHSdt/o=";

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
