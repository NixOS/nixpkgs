{
  lib,
  fetchFromGitHub,
  nix-update-script,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "oas2html";
  version = "0.1.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "affolter-engineering";
    repo = "oas2html";
    tag = finalAttrs.version;
    hash = "sha256-qC7w/FQruhyqo9hV1R1uP8hipyzrQ+CG0Osbi1+UkLY=";
  };

  cargoHash = "sha256-D7R3Rvi/KVHIES1mq3orvuXmCJE7/PJ/nstTQL93Sdc=";

  nativeInstallCheckInputs = [ versionCheckHook ];

  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tool to convert OpenAPI specifications (Swagger 2.0/OpenAPI 3.x) to self-contained HTML documentation";
    homepage = "https://github.com/affolter-engineering/oas2html";
    changelog = "https://github.com/affolter-engineering/oas2html/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "oas2html";
  };
})
