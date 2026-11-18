{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "spruce";
  version = "1.35.26";

  src = fetchFromGitHub {
    owner = "geofffranks";
    repo = "spruce";
    rev = "v${finalAttrs.version}";
    hash = "sha256-WI+acTARd8CUEG+Kt3RYEujkDFAS4Qe2AMtnbbtmw8I=";
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
