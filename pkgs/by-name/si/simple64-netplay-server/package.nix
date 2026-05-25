{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "simple64-netplay-server";
  version = "2025.03.1";

  src = fetchFromGitHub {
    owner = "gopher64";
    repo = "gopher64-netplay-server";
    tag = "v${finalAttrs.version}";
    hash = "sha256-n+au4x6d50rZI5sH7B5jdlD6vXK65UM4TRAtzpPW6ws=";
  };

  vendorHash = "sha256-E7vuGoCxCvJ/2bGDTz2NShlDjZbrPdTwLDydxop7Nio=";

  meta = {
    description = "Dedicated server for simple64 netplay";
    homepage = "https://github.com/gopher64/gopher64-netplay-server";
    license = lib.licenses.gpl3Only;
    mainProgram = "simple64-netplay-server";
    maintainers = with lib.maintainers; [ tomasajt ];
  };
})
