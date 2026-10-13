{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "sipexer";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "miconda";
    repo = "sipexer";
    rev = "v${finalAttrs.version}";
    hash = "sha256-I3Z0CK2XtKf+BXiHmLfVusCHVNN45Ej0hHOf/Csz+3w=";
  };

  vendorHash = "sha256-q2uNqKZc6Zye7YimPDrg40o68Fo4ux4fygjVjJdhqQU=";

  meta = {
    description = "Modern and flexible SIP CLI tool";
    homepage = "https://github.com/miconda/sipexer";
    changelog = "https://github.com/miconda/sipexer/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ astro ];
    mainProgram = "sipexer";
  };
})
