{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule (finalAttrs: {
  pname = "mod";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "marwan-at-work";
    repo = "mod";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-s/i2S1BbIUEXclQlv0uXlzjEvrT+udo0uzec2Una0uY=";
  };

  vendorHash = "sha256-drGfJFuEsJyZJ1x40ww0rFYsl0AkjLbznCWgluwOCYs=";

  doCheck = false;

  subPackages = [ "cmd/mod" ];

  meta = {
    description = "Automated Semantic Import Versioning Upgrades for Go";
    mainProgram = "mod";
    longDescription = ''
      Command line tool to upgrade/downgrade Semantic Import Versioning in Go
      Modules.
    '';
    homepage = "https://github.com/marwan-at-work/mod";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kalbasit ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
