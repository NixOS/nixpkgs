{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "gickup";
  version = "0.10.42";

  src = fetchFromGitHub {
    owner = "cooperspencer";
    repo = "gickup";
    tag = "v${finalAttrs.version}";
    hash = "sha256-nQermDp6w1OgZgRMknj2f6B7T9ufTZXuA8FuhGGpnWM=";
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
