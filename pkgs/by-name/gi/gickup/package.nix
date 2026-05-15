{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "gickup";
  version = "0.10.44";

  src = fetchFromGitHub {
    owner = "cooperspencer";
    repo = "gickup";
    tag = "v${finalAttrs.version}";
    hash = "sha256-AbeV/0CngNgCaLUIwv/uy8VgpiKiOXWGSjnW+xrd7gk=";
  };

  vendorHash = "sha256-lCeUEReVh0Fg1gyyTvWq2CIdQLuGCN20u9TftiokI0I=";

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
