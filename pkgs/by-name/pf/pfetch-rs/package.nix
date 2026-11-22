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
  version = "3.1.1";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Gobidev";
    repo = "pfetch-rs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/9EGw9PpF4zsWs1bZSiNd4M+FYHDx1cRXaYCD6X44WA=";
  };

  cargoHash = "sha256-JQ0c4orHmKvLQH5llrm/YwRSlMSJTBShSIiRBhQdLT8=";

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  # The Nix build sandbox has no /etc/os-release
  checkFlags = [
    "--skip=separator_override"
    "--skip=info_without_ascii_has_no_logo_padding"
    "--skip=standalone_lines_have_no_trailing_space"
    "--skip=key_value_values_align_without_title"
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
