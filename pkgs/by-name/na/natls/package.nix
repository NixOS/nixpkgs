{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "natls";
  version = "2.1.14";

  src = fetchFromGitHub {
    owner = "willdoescode";
    repo = "nat";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-4x92r6V9AvEO88gFofPTUt+mS7ZhmptDn/8O4pizSRg=";
  };

  cargoHash = "sha256-mfmG2VzBc9bRAjAF2a46JA6fzeXViVkTFUJYEIV44qo=";

  meta = {
    description = "'ls' replacement you never knew you needed";
    homepage = "https://github.com/willdoescode/nat";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ cafkafk ];
    mainProgram = "natls";
  };
})
