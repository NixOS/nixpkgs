{
  stdenv,
  lib,
  rustPlatform,
  installShellFiles,
  fetchFromGitHub,
  nix-update-script,
  buildPackages,
  sudo,
  versionCheckHook,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nh-unwrapped";
  version = "4.3.0";
  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "nh";
    tag = "v${finalAttrs.version}";
    hash = "sha256-A3bEBKJlWYqsw41g4RaTwSLUWq8Mw/zz4FpMj4Lua+c=";
  };

  strictDeps = true;

  cargoBuildFlags = [
    "-p"
    "nh"
    "-p"
    "xtask"
  ];

  nativeBuildInputs = [
    installShellFiles
  ];

  # pkgs.sudo is not available on the Darwin platform, and thus breaks build
  # if added to nativeCheckInputs. We must manually disable the tests that
  # *require* it, because they will fail when sudo is missing.
  nativeCheckInputs = lib.optionals (!stdenv.hostPlatform.isDarwin) [ sudo ];
  checkFlags = [
    # These do not work in Nix's sandbox
    "--skip"
    "test_get_build_image_variants_expression"
    "--skip"
    "test_get_build_image_variants_file"
    "--skip"
    "test_get_build_image_variants_flake"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # Tests that require sudo in PATH (not available on Darwin)
    "--skip"
    "test_build_sudo_cmd_basic"
    "--skip"
    "test_build_sudo_cmd_with_preserve_vars"
    "--skip"
    "test_build_sudo_cmd_with_preserve_vars_disabled"
    "--skip"
    "test_build_sudo_cmd_with_set_vars"
    "--skip"
    "test_build_sudo_cmd_force_no_stdin"
    "--skip"
    "test_build_sudo_cmd_with_remove_vars"
    "--skip"
    "test_build_sudo_cmd_with_askpass"
    "--skip"
    "test_build_sudo_cmd_env_added_once"
    "--skip"
    "test_elevation_strategy_passwordless_resolves"
    "--skip"
    "test_build_sudo_cmd_with_nix_config_spaces"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  postInstall = lib.optionalString (stdenv.hostPlatform.emulatorAvailable buildPackages) ''
    # Run both shell completion and manpage generation tasks. Unlike the
    # fine-grained variants, the 'dist' command doesn't allow specifying the
    # path but that's fine, because we can simply install them from the implicit
    # output directories.
    $out/bin/xtask dist

    # The dist task above should've created
    #  1. Shell completions in comp/
    #  2. The NH manpage (nh.1) in man/
    # Let's install those.
    # The important thing to note here is that installShellCompletion cannot
    # actually load *all* shell completions we generate with 'xtask dist'.
    # Elvish, for example isn't supported. So we have to be very explicit
    # about what we're installing, or this will fail.
    installShellCompletion --cmd ${finalAttrs.meta.mainProgram} ./comp/*.{bash,fish,zsh,nu}
    installManPage ./man/nh.1

    # Avoid populating PATH with an 'xtask' cmd
    rm $out/bin/xtask
  '';

  cargoHash = "sha256-BLv69rL5L84wNTMiKHbSumFU4jVQqAiI1pS5oNLY9yE=";

  passthru.updateScript = nix-update-script { };

  env.NH_REV = finalAttrs.src.tag;

  meta = {
    changelog = "https://github.com/nix-community/nh/blob/${finalAttrs.version}/CHANGELOG.md";
    description = "Yet another nix cli helper";
    homepage = "https://github.com/nix-community/nh";
    license = lib.licenses.eupl12;
    mainProgram = "nh";
    maintainers = with lib.maintainers; [
      NotAShelf
      mdaniels5757
      viperML
      midischwarz12
      faukah
    ];
  };
})
