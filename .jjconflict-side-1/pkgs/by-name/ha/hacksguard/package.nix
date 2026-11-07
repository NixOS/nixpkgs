{
  lib,
  fetchFromGitHub,
  nix-update-script,
  pkg-config,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "hacksguard";
  version = "0.3";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Rhacknarok";
    repo = "hacksguard";
    tag = finalAttrs.version;
    hash = "sha256-3HD6FFZBJ7x5uDy0UEwQVaxpuNt4O2wmJgMspeFF6iQ=";
  };

  cargoHash = "sha256-LLAPbXz8QAEUGs+37ZIFVNW1WfCVQbROfI7wQFaiy3E=";

  nativeBuildInputs = [ pkg-config ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Multi-threaded TUI malware analysis tool";
    homepage = "https://github.com/Rhacknarok/hacksguard";
    changelog = "https://github.com/Rhacknarok/hacksguard/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "hacksguard";
  };
})
