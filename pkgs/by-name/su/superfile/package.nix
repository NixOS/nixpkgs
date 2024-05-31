{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
let
  version = "1.1.2";
in
buildGoModule {
  pname = "superfile";
  inherit version;

  src =
    fetchFromGitHub {
      owner = "MHNightCat";
      repo = "superfile";
      rev = "v${version}";
      hash = "sha256-Cn03oPGT+vCZQcC62p7COx8N8BGgra+qQaZyF+osVsA=";
    }
    + "/src";

  vendorHash = "sha256-gWrhy3qzlXG072u5mW971N2Y4Vmt0KbZkB8SFsFgSzo=";

  meta = {
    changelog = "https://github.com/MHNightCat/superfile/blob/v${version}/changelog.md";
    description = "Pretty fancy and modern terminal file manager";
    homepage = "https://github.com/MHNightCat/superfile";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ momeemt ];
    mainProgram = "superfile";
  };
}
