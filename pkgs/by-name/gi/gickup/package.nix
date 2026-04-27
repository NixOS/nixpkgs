{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "gickup";
  version = "0.10.41";

  src = fetchFromGitHub {
    owner = "cooperspencer";
    repo = "gickup";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9aLBplZeNreXEmhjQJsQZ2wYQjHQxGtfaTcxO9Tw5kQ=";
  };

  vendorHash = "sha256-lmPZlCiQXwe6FWwtDyZjqmF9I2609odpY4AjkEuqPUA=";

  ldflags = [ "-X main.version=${finalAttrs.version}" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tool to backup repositories";
    homepage = "https://github.com/cooperspencer/gickup";
    changelog = "https://github.com/cooperspencer/gickup/releases/tag/v${finalAttrs.version}";
    maintainers = with lib.maintainers; [ adamcstephens ];
    mainProgram = "gickup";
    license = lib.licenses.asl20;
  };
})
