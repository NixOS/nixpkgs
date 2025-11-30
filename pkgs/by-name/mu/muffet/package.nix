{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "muffet";
  version = "2.11.1";

  src = fetchFromGitHub {
    owner = "raviqqe";
    repo = "muffet";
    tag = "v${finalAttrs.version}";
    hash = "sha256-VG8vewpC3PoKb7rUsfjXdqXGk7JDT3X9ESp3zREPiXg=";
  };

  vendorHash = "sha256-63L1uvOyAJsIOP+oM5z2YuIO9TmQJ0os1ekkg0el2k4=";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  meta = {
    description = "Website link checker which scrapes and inspects all pages in a website recursively";
    homepage = "https://github.com/raviqqe/muffet";
    changelog = "https://github.com/raviqqe/muffet/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "muffet";
  };
})
