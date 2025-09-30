{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:
buildGoModule (finalAttrs: {
  pname = "reader";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "mrusme";
    repo = "reader";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qu48ikqm4EmoeL9j67tGkX3EFBd1JdrLWhhmoElCoJY=";
  };

  vendorHash = "sha256-8IjN7hm5Rg9ItkxE9pbnkVr5t+tG95W9vvXyGaWmEIA=";

  meta = {
    description = "Lightweight tool offering better readability of web pages on the CLI";
    homepage = "https://github.com/mrusme/reader";
    changelog = "https://github.com/mrusme/reader/releases";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ theobori ];
    mainProgram = "reader";
  };
})
