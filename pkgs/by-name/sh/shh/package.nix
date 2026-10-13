{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  installShellFiles,
  strace,
  systemd,
  stdenv,
  enableDocumentationFeature ? true,
  enableDocumentationGeneration ? true,
}:
let
  isNativeDocgen =
    (stdenv.buildPlatform.canExecute stdenv.hostPlatform) && enableDocumentationFeature;
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "shh";
  version = "2026.3.8";

  src = fetchFromGitHub {
    owner = "desbma";
    repo = "shh";
    tag = "v${finalAttrs.version}";
    hash = "sha256-PWbPyhn103eLHelhf+m1iIIaKDCooiIRMzrn9xPTzoA=";
  };

  cargoHash = "sha256-zE4qRXrQHqppTmZ9rHeqt4mvMgoRIzX73/CPf4IRgYo=";

  patches = [
    ./fix_run_checks.patch
  ];

  env = {
    SHH_STRACE_BIN_PATH = lib.getExe strace;
    # RUST_BACKTRACE = 1;
  };

  buildFeatures = lib.optional enableDocumentationFeature "generate-extras";

  nativeBuildInputs = [
    installShellFiles
    systemd
  ]
  ++ (lib.optional (!isNativeDocgen) strace);

  # todo elvish
  postInstall = lib.optionalString enableDocumentationGeneration ''
    mkdir -p target/{mangen,shellcomplete}

    ${
      if isNativeDocgen then
        ''
          $out/bin/shh gen-man-pages target/mangen
          $out/bin/shh gen-shell-completions target/shellcomplete
        ''
      else
        ''
          unset SHH_STRACE_BIN_PATH
          cargo run --features generate-extras -- gen-man-pages target/mangen
          cargo run --features generate-extras -- gen-shell-completions target/shellcomplete
        ''
    }

    installManPage target/mangen/*

    installShellCompletion --cmd ${finalAttrs.meta.mainProgram} \
      target/shellcomplete/${finalAttrs.meta.mainProgram}.{bash,fish} \
      --zsh target/shellcomplete/_${finalAttrs.meta.mainProgram}
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Automatic systemd service hardening guided by strace profiling";
    homepage = "https://github.com/desbma/shh";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    changelog = "https://github.com/desbma/shh/blob/v${finalAttrs.version}/CHANGELOG.md";
    mainProgram = "shh";
    maintainers = with lib.maintainers; [
      erdnaxe
      kuflierl
      jk
    ];
  };
})
