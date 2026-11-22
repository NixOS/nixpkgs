{
  lib,
  aws-lc,
  pkg-config,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "corrode-scanner";
  version = "0.6.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "ul0gic";
    repo = "corrode";
    tag = "v${finalAttrs.version}";
    hash = "sha256-f0EQ2m8yJEAUN7GFsdalVSwTDUfrOvLtX5HebHz7+Pg=";
  };

  cargoHash = "sha256-1NGrkhYaq4OD8gW0KltCLQjOkgACqkwXCnV68LZzwxM=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ aws-lc ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Security scanner for finding exposed credentials, secrets, and vulnerabilities";
    homepage = "https://github.com/ul0gic/corrode";
    changelog = "https://github.com/ul0gic/corrode/releases/tag/${finalAttrs.src.tag}";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "corrode-scanner";
  };
})
