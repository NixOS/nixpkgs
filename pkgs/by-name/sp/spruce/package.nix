{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "spruce";
  version = "1.35.14";

  src = fetchFromGitHub {
    owner = "geofffranks";
    repo = "spruce";
    rev = "v${finalAttrs.version}";
    hash = "sha256-EKhspLsuovnzJVFyp8+0cUSA+kRzPwJ0YHN5iUe5NRM=";
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
