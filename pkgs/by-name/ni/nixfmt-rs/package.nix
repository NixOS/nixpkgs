{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
  nixfmt,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nixfmt-rs";
  version = "0.1.4";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "Mic92";
    repo = "nixfmt-rs";
    tag = finalAttrs.version;
    hash = "sha256-lfT+cFys0iJGkOgLO8LR7lnKMG7ZKJTVvOCm6dSBf8w=";
  };

  cargoHash = "sha256-TmZi99xxTlSTpqr6k29CsnTK8qfj5gjs1AGkx1hcXCg=";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  nativeCheckInputs = [ nixfmt ];

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/Mic92/nixfmt-rs/releases/tag/${finalAttrs.version}";
    description = "Rust reimplementation of nixfmt that produces byte-identical output to the Haskell original";
    homepage = "https://github.com/Mic92/nixfmt-rs";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [
      drupol
      mic92
    ];
    mainProgram = "nixfmt";
  };
})
