{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule (finalAttrs: {
  pname = "mod";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "marwan-at-work";
    repo = "mod";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-kk/+ePZpUc9Q8YYh4mbPy+n4VP7/NFL1wsMvmz9/Jog=";
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
