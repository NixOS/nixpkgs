{
  lib,
  nix-update-script,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "goda";
  version = "0.9.4";

  src = fetchFromGitHub {
    owner = "loov";
    repo = "goda";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ARiI5varW7p7eX58N8mtS6yeXeTlZfiiTFgI8pcDD6M=";
  };

  vendorHash = "sha256-jtri/73UnpI5oyykW2DYiH0vra62+jk8VIHhcWT2oJA=";

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/loov/goda";
    description = "Go Dependency Analysis toolkit";
    maintainers = with lib.maintainers; [ michaeladler ];
    license = lib.licenses.mit;
    mainProgram = "goda";
  };
})
