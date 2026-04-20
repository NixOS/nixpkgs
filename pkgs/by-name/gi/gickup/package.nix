{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "gickup";
  version = "0.10.40";

  src = fetchFromGitHub {
    owner = "cooperspencer";
    repo = "gickup";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/hdCgo09sMbwbF3E5vOEuyYXF/qm0H/79cDuQOlFy/Y=";
  };

  vendorHash = "sha256-9t+rjK385Co6RKeihxJprGJz0SjzKFSKNix2Sq0ZlSg=";

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
