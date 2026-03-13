{
  lib,
  rustPlatform,
  fetchFromGitHub,
  openssl,
  pkg-config,
  versionCheckHook,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "foodfetch";
  version = "0.1.1";
  src = fetchFromGitHub {
    owner = "noahfraiture";
    repo = "foodfetch";
    tag = "v${finalAttrs.version}";
    hash = "sha256-TUgj3zS18lCtkyxYrG4f156YqFSCGXzfbK6b+Owacto=";
  };

  cargoHash = "sha256-ZPV6sDQHV+G0HxRAVlcilh4tCCQspTnxnH1aHxVP8tI=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/noahfraiture/foodfetch/releases/tag/v${finalAttrs.version}";
    description = "Yet another fetch to quickly get recipes";
    homepage = "https://github.com/noahfraiture/foodfetch";
    license = lib.licenses.mit;
    mainProgram = "foodfetch";
    maintainers = with lib.maintainers; [ noahfraiture ];
  };
})
