{
  lib,
  fetchFromGitHub,
  nix-update-script,
  pkg-config,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nfswolf";
  version = "1.3.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "StrongWind1";
    repo = "NFSWolf";
    tag = "v${finalAttrs.version}";
    hash = "sha256-p33WLhqUYqcwDGDJ9Wxm/5aU4ZKj6YqcCr245Y+1Mo0=";
  };

  cargoHash = "sha256-vNKglAwJSxNOeMzN7a1lJ6vOIU67ja8BqUTOstqn/T0=";

  nativeBuildInputs = [ pkg-config ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "NFS security toolkit";
    homepage = "https://github.com/StrongWind1/NFSWolf";
    changelog = "https://github.com/StrongWind1/NFSWolf/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "nfswolf";
    platforms = lib.platforms.linux;
  };
})
