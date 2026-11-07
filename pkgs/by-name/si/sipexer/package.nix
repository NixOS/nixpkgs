{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "sipexer";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "miconda";
    repo = "sipexer";
    rev = "v${finalAttrs.version}";
    hash = "sha256-IOYXhzwvEMeiBl7Fx+f0iBOTQIURP7FU4UxcVFSauH4=";
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
