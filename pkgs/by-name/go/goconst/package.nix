{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "goconst";
  version = "1.11.0";

  excludedPackages = [ "tests" ];

  src = fetchFromGitHub {
    owner = "jgautheron";
    repo = "goconst";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-rtf5xC83nOO9oRtBFxDqWD/qKtYfTYHDS4YGW7omVYs=";
  };

  vendorHash = null;

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Find in Go repeated strings that could be replaced by a constant";
    mainProgram = "goconst";
    homepage = "https://github.com/jgautheron/goconst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kalbasit ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
