{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "abtop";
  version = "0.5.5";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "graykode";
    repo = "abtop";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8dBAdaZ6SkSSktmk/KejnTJDikEQj1jBQ2LoiK54Pzk=";
  };

  cargoHash = "sha256-EGx/k79B5ceC8/EFfVH9HtZUedkRNsV74vdyAPxh8ro=";

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
