{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "simple64-netplay-server";
  version = "2025.03.1";

  src = fetchFromGitHub {
    owner = "simple64";
    repo = "simple64-netplay-server";
    tag = "v${version}";
    hash = "sha256-n+au4x6d50rZI5sH7B5jdlD6vXK65UM4TRAtzpPW6ws=";
  };

  vendorHash = "sha256-E7vuGoCxCvJ/2bGDTz2NShlDjZbrPdTwLDydxop7Nio=";

  meta = {
    description = "Dedicated server for simple64 netplay";
    homepage = "https://github.com/simple64/simple64-netplay-server";
    license = lib.licenses.gpl3Only;
    mainProgram = "simple64-netplay-server";
    maintainers = with lib.maintainers; [ tomasajt ];
  };
}
