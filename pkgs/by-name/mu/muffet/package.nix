{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "muffet";
  version = "2.11.5";

  src = fetchFromGitHub {
    owner = "raviqqe";
    repo = "muffet";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dPScTdOGR3cgcFBa09iez0/DkCugXseIGGRMiCPJeYo=";
  };

  vendorHash = "sha256-FXV+wP22R3gPAMGbhyz/v1Rk7w6z2ovoWirbLM1Wl24=";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    description = "Website link checker which scrapes and inspects all pages in a website recursively";
    homepage = "https://github.com/raviqqe/muffet";
    changelog = "https://github.com/raviqqe/muffet/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hythera ];
    mainProgram = "muffet";
  };
})
