{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "sipexer";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "miconda";
    repo = "sipexer";
    rev = "v${finalAttrs.version}";
    hash = "sha256-7L29nyFOc/5XAHpzGsFSngxMTwwIDkmwhIKIjHYGszc=";
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
