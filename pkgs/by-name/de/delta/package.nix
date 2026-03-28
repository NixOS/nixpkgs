{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  pkg-config,
  oniguruma,
  stdenv,
  git,
  zlib,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "delta";
  version = "0.19.1";

  src = fetchFromGitHub {
    owner = "dandavison";
    repo = "delta";
    tag = finalAttrs.version;
    hash = "sha256-JkJfyVgaiXBKgin9Lf+zB7znDd9BkX4GBX54Gt1LM7M=";
  };

  cargoHash = "sha256-CLHJfwaNsOsCONadlLUjTwx1Sr+2ftKsJh8XrCoJ24I=";

  nativeBuildInputs = [
    installShellFiles
    pkg-config
  ];

  buildInputs = [
    oniguruma
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    zlib
  ];

  nativeCheckInputs = [ git ];

  env = {
    RUSTONIG_SYSTEM_LIBONIG = true;
  };

  postInstall = ''
    installShellCompletion --cmd delta \
      etc/completion/completion.{bash,fish,zsh}
  '';

  # test_env_parsing_with_pager_set_to_bat sets environment variables,
  # which can be flaky with multiple threads:
  # https://github.com/dandavison/delta/issues/1660
  dontUseCargoParallelTests = true;

  checkFlags = lib.optionals stdenv.hostPlatform.isDarwin [
    # This test tries to read /etc/passwd, which fails with the sandbox
    # enabled on Darwin
    "--skip=test_diff_real_files"
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  meta = {
    homepage = "https://github.com/dandavison/delta";
    description = "Syntax-highlighting pager for git";
    changelog = "https://github.com/dandavison/delta/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      zowoq
      SuperSandro2000
    ];
    mainProgram = "delta";
  };
})
