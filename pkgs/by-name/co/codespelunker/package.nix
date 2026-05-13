{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "codespelunker";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "boyter";
    repo = "cs";
    rev = "v${finalAttrs.version}";
    hash = "sha256-cPaAuZJ/Flea4BZ2LTprE5BFtHqgVCuF+2VLShgkCrQ=";
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
