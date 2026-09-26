{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "codespelunker";
  version = "3.2.0";

  src = fetchFromGitHub {
    owner = "boyter";
    repo = "cs";
    rev = "v${finalAttrs.version}";
    hash = "sha256-yjzqy0YgpKUR1ZlRXpBW9GBoLmXZ1AjTfPfkxD9Ht/s=";
  };

  vendorHash = null;

  subPackages = [ "." ];

  meta = {
    description = "Command code search tool";
    homepage = "https://github.com/boyter/cs";
    license = with lib.licenses; [
      mit
      unlicense
    ];
    maintainers = with lib.maintainers; [ viraptor ];
    mainProgram = "cs";
  };
})
