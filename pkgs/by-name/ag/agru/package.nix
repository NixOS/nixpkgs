{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "agru";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "etkecc";
    repo = "agru";
    rev = "v${finalAttrs.version}";
    hash = "sha256-aE2DlJKq2xEvgXAjQTzYRQZbFw11uTWZqVeNL9xWG0Y=";
  };

  vendorHash = null;

  __structuredAttrs = true;

  meta = {
    description = "Faster ansible-galaxy substitute";
    homepage = "github.com/etkecc/";
    license = lib.licenses.agpl3Only;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [ jackoe ];
    mainProgram = "agru";
  };
})
