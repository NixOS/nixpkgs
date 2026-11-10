{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "muffet";
  version = "2.11.7";

  src = fetchFromGitHub {
    owner = "raviqqe";
    repo = "muffet";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qPURL4sF52pbmZ+NqQjeIMetef7Kz8OLeyLkHFHvHlM=";
  };

  vendorHash = "sha256-RwWiLYaoSUvEY5kzKCvW1gp4EVlrZW/8Lmfi+YV9Lec=";

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
