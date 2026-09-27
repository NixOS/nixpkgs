{
  lib,
  fetchFromGitHub,
  libpcap,
  nix-update-script,
  pkg-config,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "asphyxia";
  version = "0.10.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "jtprogru";
    repo = "asphyxia";
    tag = finalAttrs.version;
    hash = "sha256-XjpGhdHYzTCFtQ2W9KD8VY7RSvQPPgbxJD80GIAaKFM=";
  };

  cargoHash = "sha256-lOH8mrZiauXoI7jYFHQ/klo9enS0aOixk5b6InUED2o=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ libpcap ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Parallel network scanner";
    homepage = "https://github.com/jtprogru/asphyxia";
    changelog = "https://github.com/jtprogru/asphyxia/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "asphyxia";
  };
})
