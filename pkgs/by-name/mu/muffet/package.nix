{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "muffet";
  version = "2.11.3";

  src = fetchFromGitHub {
    owner = "raviqqe";
    repo = "muffet";
    tag = "v${finalAttrs.version}";
    hash = "sha256-c/ionFvWOPZ/MFNos/Q0KdlFH9qlOeAXldQZljaEF8k=";
  };

  vendorHash = "sha256-ZTPaNeozhbl6FReJowzVHDcSGLCXdt8e3UEW69lFx88=";

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
