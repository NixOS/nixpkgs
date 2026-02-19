{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "codespelunker";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "boyter";
    repo = "cs";
    rev = "v${finalAttrs.version}";
    hash = "sha256-knsEEpmBuFO5UkUenjVilSg8h+MMGnmbDX0DrAlg98s=";
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
