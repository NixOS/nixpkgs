{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "dalfox";
  version = "2.13.0";

  src = fetchFromGitHub {
    owner = "hahwul";
    repo = "dalfox";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GAlLmgIs2r8VCm69MuFPuQERHSZYAE/Zz8/y4ewYJME=";
  };

  vendorHash = "sha256-UmQGsuLOpUJpGnWBot6YjG56LLNYHjm9mCejhEzkoBk=";

  ldflags = [
    "-w"
    "-s"
  ];

  # Tests require network access
  doCheck = false;

  meta = {
    description = "Tool for analysing parameter and XSS scanning";
    homepage = "https://github.com/hahwul/dalfox";
    changelog = "https://github.com/hahwul/dalfox/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "dalfox";
  };
})
