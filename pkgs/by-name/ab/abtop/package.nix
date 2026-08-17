{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "abtop";
  version = "0.5.1";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "graykode";
    repo = "abtop";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2m0FYv2HouFqnmDaG6ounc8VJxlEK3N3uTBZyNiFwzI=";
  };

  cargoHash = "sha256-0sAjql2pH41dHdmV0uC4jjj6J1OFjMdEY1B+4C4id3Y=";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Like htop, but for AI coding agents";
    homepage = "https://github.com/graykode/abtop";
    changelog = "https://github.com/graykode/abtop/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ Br1ght0ne ];
    mainProgram = "abtop";
  };
})
