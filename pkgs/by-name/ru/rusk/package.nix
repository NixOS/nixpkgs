{
  fetchFromGitHub,
  lib,
  nix-update-script,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rusk";
  version = "0.6.10";

  src = fetchFromGitHub {
    owner = "tagirov";
    repo = "rusk";
    tag = finalAttrs.version;
    hash = "sha256-gZTnevMzn/L26OoDdYb/i3vL3xcM72cuNht3NU5G7TA=";
  };

  cargoHash = "sha256-LZUVajVyPIPBWz/9aNOBlVqeLS7OVfbJfT2qDhznPOY=";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  doCheck = false; # FIXME: https://github.com/tagirov/rusk/issues/8

  meta = {
    description = "Minimal terminal task manager";
    homepage = "https://github.com/tagirov/rusk";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "rusk";
  };
})
