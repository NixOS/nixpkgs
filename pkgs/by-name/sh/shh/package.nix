{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  installShellFiles,
  python3,
  strace,
  systemd,
  iproute2,
  stdenv,
  enableDocumentationFeature ? true,
  enableDocumentationGeneration ? true,
}:
let
  isNativeDocgen =
    (stdenv.buildPlatform.canExecute stdenv.hostPlatform) && enableDocumentationFeature;
in
rustPlatform.buildRustPackage rec {
  pname = "shh";
  version = "2025.6.5";

  src = fetchFromGitHub {
    owner = "desbma";
    repo = "shh";
    tag = "v${version}";
    hash = "sha256-cKN5SK7pVw4Ey6QmCZRYIlDPJ69eg9ihQ1M2vZDmGZ0=";
  };

  cargoHash = "sha256-09mQDautFnL0RYfIfn6KC2T7Ah57gV7JD1JkqmApmYI=";

  patches = [
    ./fix_run_checks.patch
  ];

  env = {
    SHH_STRACE_BIN_PATH = lib.getExe strace;
  };

  buildFeatures = lib.optional enableDocumentationFeature "generate-extra";

  checkFlags = [
    # no access to system modules in build env
    "--skip=run_ls_modules"
    # missing systemd daemon in build env
    "--skip=run_systemctl"
    # no raw socket cap in nix build
    "--skip=run_ping_4"
    "--skip=run_ping_6"
  ];

  buildInputs = [
    strace
    systemd
  ];

  nativeBuildInputs = [
    installShellFiles
    systemd
    strace
  ];

  nativeCheckInputs = [
    python3
    iproute2
  ];

  # todo elvish
  postInstall = lib.optionalString enableDocumentationGeneration ''
    mkdir -p target/{mangen,shellcomplete}

    ${
      if isNativeDocgen then
        ''
          $out/bin/shh gen-man-pages target/mangen
          $out/bin/shh gen-shell-complete target/shellcomplete
        ''
      else
        ''
          unset SHH_STRACE_BIN_PATH
          cargo run --features generate-extra -- gen-man-pages target/mangen
          cargo run --features generate-extra -- gen-shell-complete target/shellcomplete
        ''
    }

    installManPage target/mangen/*

    installShellCompletion --cmd ${pname} \
      target/shellcomplete/${pname}.{bash,fish} \
      --zsh target/shellcomplete/_${pname}
  '';

  # RUST_BACKTRACE = 1;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Automatic systemd service hardening guided by strace profiling";
    homepage = "https://github.com/desbma/shh";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    changelog = "https://github.com/desbma/shh/blob/v${version}/CHANGELOG.md";
    mainProgram = "shh";
    maintainers = with lib.maintainers; [
      erdnaxe
      kuflierl
    ];
  };
}
