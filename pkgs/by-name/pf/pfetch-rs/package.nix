{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "pfetch-rs";
  version = "3.0.2";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Gobidev";
    repo = "pfetch-rs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-RrsmCSoiTfdWOL0FLbKR8ZQyLMnEnY5fZ0S4pLbwvWY=";
  };

  cargoHash = "sha256-65v8mNYa+zNbAkCQNWGpb9h0bSi66R4p6cKRZ6/wuaM=";

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  # The Nix build sandbox has no /etc/os-release
  checkFlags = [
    "--skip=separator_override"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # Title renders "user@host", which libmacchina can't resolve in the sandbox
    "--skip=info_filter"
    "--skip=logo_override"
    "--skip=raw_logo_from_stdin"
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Rewrite of the pfetch system information tool in Rust";
    homepage = "https://github.com/Gobidev/pfetch-rs";
    changelog = "https://github.com/Gobidev/pfetch-rs/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      gobidev
      lonerOrz
    ];
    mainProgram = "pfetch";
  };
})
