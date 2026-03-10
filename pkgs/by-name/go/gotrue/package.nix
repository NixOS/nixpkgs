{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "gotrue";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "netlify";
    repo = "gotrue";
    rev = "v${finalAttrs.version}";
    hash = "sha256-9h6CyCY7741tJR+qWDLwgPkAtE/kmaoTqlXEY+mOW58=";
  };

  vendorHash = "sha256-x96+l9EBzYplGRFHsfQazSjqZs35bdXQEJv3pBuaJVo=";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/netlify/gotrue/cmd.Version=${finalAttrs.version}"
  ];

  # integration tests require network access
  doCheck = false;

  meta = {
    homepage = "https://github.com/netlify/gotrue";
    description = "SWT based API for managing users and issuing SWT tokens";
    mainProgram = "gotrue";
    changelog = "https://github.com/netlify/gotrue/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
