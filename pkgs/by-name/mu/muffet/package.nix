{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "muffet";
  version = "2.11.0";

  src = fetchFromGitHub {
    owner = "raviqqe";
    repo = "muffet";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GfRR+9PdfY63Pzv2XZenKs8XXAKRr9qMzcHOVhl+hv4=";
  };

  vendorHash = "sha256-oidOSV8y0VwTabipe7XwurUAra9F65nkTXslwXJ94Jw=";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  meta = {
    description = "Website link checker which scrapes and inspects all pages in a website recursively";
    homepage = "https://github.com/raviqqe/muffet";
    changelog = "https://github.com/raviqqe/muffet/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ figsoda ];
    mainProgram = "muffet";
  };
})
