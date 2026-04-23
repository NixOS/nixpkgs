{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "spruce";
  version = "1.32.0";

  src = fetchFromGitHub {
    owner = "geofffranks";
    repo = "spruce";
    rev = "v${finalAttrs.version}";
    hash = "sha256-KTitSKzXa2HudgByLl5P1cWBr0BxxuOO1GRKI26galE=";
  };

  vendorHash = null;

  meta = {
    description = "BOSH template merge tool";
    mainProgram = "spruce";
    homepage = "https://github.com/geofffranks/spruce";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ risson ];
  };
})
