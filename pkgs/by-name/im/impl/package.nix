{
  buildGoModule,
  lib,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "impl";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "josharian";
    repo = "impl";
    rev = "v${finalAttrs.version}";
    hash = "sha256-E+QnG0rmr+xartUe3y7RLzOIRapphiB3cUijZER0zDs=";
  };

  vendorHash = "sha256-vTqDoM/LK5SHkayLKYig+tCrXLelOoILmQGCxlTWHog=";

  meta = {
    description = "Generate method stubs for implementing an interface";
    mainProgram = "impl";
    homepage = "https://github.com/josharian/impl";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kalbasit ];
  };
})
