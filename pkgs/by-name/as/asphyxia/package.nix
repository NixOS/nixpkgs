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
  version = "0.11.1";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "jtprogru";
    repo = "asphyxia";
    tag = finalAttrs.version;
    hash = "sha256-VKxCDvL5y5K0GkV1tGN9SrWlewtoW/CSR4B/cu20Bxg=";
  };

  cargoHash = "sha256-rRzzuVAM0Kf6Fc7tcUzSstT7WMMDIgCRoMNDqjbz1NA=";

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
