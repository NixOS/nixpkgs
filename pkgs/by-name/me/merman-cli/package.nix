{
  lib,
  rustPlatform,
  fetchFromGitHub,
  cmake,
  perl,
  installShellFiles,
  python3,
  testers,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "merman-cli";
  version = "0.8.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Latias94";
    repo = "merman";
    tag = "v${finalAttrs.version}";
    hash = "sha256-PPegdxdgT7OF5jzFskj3r5Ftwca0Z2A61q+Y2zLQuZ0=";
  };

  cargoLock.lockFile = ./Cargo.lock;

  buildType = "dist";
  buildNoDefaultFeatures = true;
  buildFeatures = [
    "all-diagrams"
    "analysis"
    "ascii"
    "icons"
    "jpeg"
    "layout-cytoscape"
    "layout-elk"
    "markdown"
    "math"
    "network-icons"
    "parallel-markdown"
    "pdf"
    "png"
    "rustdoc"
    "shell-completions"
    "svg"
    "system-clock"
    "system-random"
    "system-timezone"
    "system-timing"
  ];
  cargoBuildFlags = [
    "--package"
    "merman-cli"
    "--bin"
    "merman-cli"
  ];

  nativeBuildInputs = [
    cmake
    perl
    installShellFiles
  ];

  env.AWS_LC_SYS_USE_SYSTEM = "0";

  # Follow the upstream Nix owner's installed-CLI checks instead of workspace tests.
  doCheck = false;

  postInstall = ''
    installShellCompletion --cmd merman-cli \
      --bash crates/merman-cli/assets/completions/merman-cli.bash \
      --zsh crates/merman-cli/assets/completions/_merman-cli \
      --fish crates/merman-cli/assets/completions/merman-cli.fish
    install -Dm0644 crates/merman-cli/assets/completions/merman-cli.ps1 \
      "$out/share/pwsh/completions/_merman-cli.ps1"
    install -Dm0644 crates/merman-cli/assets/completions/merman-cli.elv \
      "$out/share/elvish/lib/merman-cli.elv"
    installManPage crates/merman-cli/assets/man/*.1

    doc_dir="$out/share/doc/merman-cli"
    mkdir -p "$doc_dir"
    install -m0644 LICENSE-APACHE LICENSE-MIT THIRD_PARTY_NOTICES.md "$doc_dir/"
    cp -R THIRD_PARTY_LICENSES "$doc_dir/"
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ python3 ];
  installCheckPhase = ''
    runHook preInstallCheck
    ${lib.getExe python3} scripts/verify_cli_installation.py \
      --package-version ${lib.escapeShellArg finalAttrs.version} \
      --prefix "$out" \
      --binary "$out/bin/merman-cli" \
      --contract-root "$PWD" \
      --completion-layout nix
    cmp LICENSE-APACHE "$out/share/doc/merman-cli/LICENSE-APACHE"
    cmp LICENSE-MIT "$out/share/doc/merman-cli/LICENSE-MIT"
    cmp THIRD_PARTY_NOTICES.md "$out/share/doc/merman-cli/THIRD_PARTY_NOTICES.md"
    diff -qr THIRD_PARTY_LICENSES "$out/share/doc/merman-cli/THIRD_PARTY_LICENSES"
    runHook postInstallCheck
  '';

  passthru = {
    tests.version = testers.testVersion { package = finalAttrs.finalPackage; };
  };

  meta = {
    description = "Headless Mermaid-compatible diagram CLI";
    homepage = "https://github.com/Latias94/merman";
    changelog = "https://github.com/Latias94/merman/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = with lib.licenses; [
      asl20
      mit
    ];
    mainProgram = "merman-cli";
    maintainers = with lib.maintainers; [ Latias94 ];
    platforms = [
      "aarch64-darwin"
      "aarch64-linux"
      "x86_64-darwin"
      "x86_64-linux"
    ];
  };
})
