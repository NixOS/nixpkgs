{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "mev-boost";
  version = "1.11";
  src = fetchFromGitHub {
    owner = "flashbots";
    repo = "mev-boost";
    rev = "v${finalAttrs.version}";
    hash = "sha256-uEIZojmzSVyF+ZOQsSqZA0MB2cT8I/JHGfgKVI48PIk=";
  };

  vendorHash = "sha256-dIc0ZHTx+7P621FvfDKlItc/FazUpwxRmDQF2SNVIwA=";

  meta = {
    description = "Ethereum block-building middleware";
    homepage = "https://github.com/flashbots/mev-boost";
    license = lib.licenses.mit;
    mainProgram = "mev-boost";
    maintainers = with lib.maintainers; [ ekimber ];
    platforms = lib.platforms.unix;
  };
})
