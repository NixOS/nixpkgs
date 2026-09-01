{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule (finalAttrs: {
  pname = "errcheck";
  version = "1.20.0";

  src = fetchFromGitHub {
    owner = "kisielk";
    repo = "errcheck";
    rev = "v${finalAttrs.version}";
    hash = "sha256-bXt0GuXV4Amg8dE261KC8f6C5sOclOzhFj1D4/kaBYs=";
  };

  vendorHash = "sha256-mhpKZ47jaX3pp/5TOXADip0iPosIDl5FzpaID98rpHQ=";

  subPackages = [ "." ];

  meta = {
    description = "Checks for unchecked errors in go programs";
    mainProgram = "errcheck";
    homepage = "https://github.com/kisielk/errcheck";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kalbasit ];
  };
})
