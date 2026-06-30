{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "agru";
  version = "0.1.19";

  src = fetchFromGitHub {
    owner = "etkecc";
    repo = "agru";
    rev = "v${finalAttrs.version}";
    hash = "sha256-K48f4wDGH7SYy69CYsTjM0WnwUxzWctV1NFR8IB/bYY=";
  };

  vendorHash = null;

  meta = {
    description = "Faster ansible-galaxy substitute";
    homepage = "github.com/etkecc/";
    license = lib.licenses.agpl3Only;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [ jackoe ];
    mainProgram = "agru";
  };
})
