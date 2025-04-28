{
  stdenv,
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
  nix-update-script,
  curl,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "leo-lang";
  version = "3.2.0";

  src = fetchFromGitHub {
    owner = "ProvableHQ";
    repo = "leo";
    tag = "v${finalAttrs.version}";
    hash = "sha256-FcAV3Zz6yllvkfErFHGSGJJWpQO38AC8z2qujzE2XHU=";
    fetchSubmodules = true;
  };

  patches = [ ./0001-remove-update-subcommand.patch ];

  cargoHash = "sha256-eSwFUA+wCUEvhmNEOQmRCDrNHT+DWTvE8JMxmBnZiqA=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ curl ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgram = "${placeholder "out"}/bin/leo";
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  # checkFlags = lib.optionals stdenv.hostPlatform.isDarwin [
  checkFlags = [
    # fail in Darwin sandbox
    "--skip=cli::cli::tests::nested_local_dependency_run_test"
    "--skip=cli::cli::tests::nested_network_dependency_run_test"
    "--skip=cli::cli::tests::relaxed_shadowing_run_test"
    "--skip=cli::cli::tests::relaxed_struct_shadowing_run_test"
  ];

  meta = {
    description = "Functional, statically-typed programming language built for writing private applications";
    homepage = "https://github.com/ProvableHQ/leo";
    changelog = "https://github.com/ProvableHQ/leo/releases/tag/${finalAttrs.version}";
    maintainers = with lib.maintainers; [ anstylian ];
    mainProgram = "leo";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.unix;
  };
})
