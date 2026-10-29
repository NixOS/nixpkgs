{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "sleek";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "nrempel";
    repo = "sleek";
    rev = "v${finalAttrs.version}";
    hash = "sha256-4op0EqJWRGEQwXu5DjFBM1ia9nKiE5QTg+pbaeg4+ag=";
  };

  cargoHash = "sha256-0AB2Z++WnOQ06CkKIHBydgV4VlLGqhlKGAQ0blPOFPo=";

  meta = {
    description = "CLI tool for formatting SQL";
    homepage = "https://github.com/nrempel/sleek";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ xrelkd ];
    mainProgram = "sleek";
  };
})
