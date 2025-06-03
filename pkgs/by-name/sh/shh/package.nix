{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  fetchpatch,
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
  version = "2025.4.12";

  src = fetchFromGitHub {
    owner = "desbma";
    repo = "shh";
    tag = "v${version}";
    hash = "sha256-+JWz0ya6gi8pPERnpAcQIe7zZUzWGxha+9/gizMVtEw=";
  };

  cargoHash = "sha256-rrOH76LHYSEeuNiMIICpAO7U/sz5V0JRO22mbIICQWw=";

  # needs to be done this way to bypass patch conflicts
  cargoPatches = [
    (fetchpatch {
      # to be removed after next release
      name = "refactor-man-page-generation-command.patch";
      url = "https://github.com/desbma/shh/commit/849b9a6646981c83a72a977b6398371e29d3b928.patch";
      hash = "sha256-LZlUFfPtt2ScTxQbQ9j3Kzvp7T4MCFs92cJiI3YbWns=";
    })
    (fetchpatch {
      # to be removed after next release
      name = "support-shell-auto-complete.patch";
      url = "https://github.com/desbma/shh/commit/74914dc8cfd74dbd7e051a090cc4c1f561b8cdde.patch";
      hash = "sha256-WgKRQAEwSpXdQUnrZC1Bp4RfKg2J9kPkT1k6R2wwgT8=";
    })
  ];

  patches = [
    ./fix_run_checks.patch
    (fetchpatch {
      # to be removed after next release
      name = "feat-static-strace-path-support-at-compile-time.patch";
      url = "https://github.com/desbma/shh/commit/da62ceeb227de853be06610721744667c6fe994b.patch";
      hash = "sha256-p/W7HRZZ4TpIwrWN8wQB/SH3C8x3ZLXzwGV50oK/znQ=";
    })
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
