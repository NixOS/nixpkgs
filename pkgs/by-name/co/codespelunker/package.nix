{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "codespelunker";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "boyter";
    repo = "cs";
    rev = "v${finalAttrs.version}";
    hash = "sha256-FZf3aRozpXWTRDrNDRxb1dGBXiLVEYOUd8a/hqzThps=";
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
