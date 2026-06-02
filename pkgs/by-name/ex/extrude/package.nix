{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "extrude";
  version = "0.0.12";

  src = fetchFromGitHub {
    owner = "liamg";
    repo = "extrude";
    rev = "v${finalAttrs.version}";
    hash = "sha256-7gCEBhnNU5CqC5n0KP4Dd/fmddPRwNqyMFXTrRrJjfU=";
  };

  vendorHash = "sha256-8qjIYPkWtYTvl7wAnefpZAjbNSQLQFqRnGGccYZ8ZmU=";

  meta = {
    description = "Tool to analyse binaries for missing security features";
    mainProgram = "extrude";
    homepage = "https://github.com/liamg/extrude";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
  };
})
