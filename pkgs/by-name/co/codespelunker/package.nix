{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "codespelunker";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "boyter";
    repo = "cs";
    rev = "v${finalAttrs.version}";
    hash = "sha256-iRp5H+lZXks3MUxA1v/ZLMJnh/4T2KljOCylBcL05yc=";
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
