{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  libgit2,
  rust-jemalloc-sys,
  zlib,
  gitMinimal,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "biome";
  version = "2.4.4";

  src = fetchFromGitHub {
    owner = "biomejs";
    repo = "biome";
    rev = "@biomejs/biome@${finalAttrs.version}";
    hash = "sha256-d7FSqOOAcJ/llq+REPOCvJAbHFanLzgOuwcOURf+NPg=";
  };

  cargoHash = "sha256-g8ov3SrcpHuvdg7qbbDMbhYMSAGCxJgQyWY+W/Sh/pM=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libgit2
    rust-jemalloc-sys
    zlib
  ];

  nativeCheckInputs = [ gitMinimal ];

  cargoBuildFlags = [ "-p=biome_cli" ];
  cargoTestFlags = finalAttrs.cargoBuildFlags ++ [
    "--"
    # fails due to cargo insta
    "--skip=commands::check::print_json"
    "--skip=commands::check::print_json_pretty"
    "--skip=commands::explain::explain_logs"
    "--skip=commands::format::print_json"
    "--skip=commands::format::print_json_pretty"
    "--skip=commands::format::should_format_files_in_folders_ignored_by_linter"
    "--skip=cases::migrate_v2::should_successfully_migrate_sentry"
    "--skip=cases::help::check_help"
    "--skip=cases::help::ci_help"
    "--skip=cases::help::format_help"
    "--skip=cases::help::lint_help"
    "--skip=cases::help::lsp_proxy_help"
    "--skip=cases::help::migrate_help"
    "--skip=cases::help::rage_help"
    "--skip=cases::help::start_help"
  ];

  env = {
    BIOME_VERSION = finalAttrs.version;
    LIBGIT2_NO_VENDOR = 1;
    INSTA_UPDATE = "no";
  };

  postInstall = ''
    # Installs biome schema aside with the package
    install -Dm644 packages/@biomejs/biome/configuration_schema.json $out/share/schema.json
  '';

  preCheck = ''
    # tests assume git repository
    git init

    # tests assume $BIOME_VERSION is unset
    unset BIOME_VERSION
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Toolchain of the web";
    homepage = "https://biomejs.dev/";
    changelog = "https://github.com/biomejs/biome/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      isabelroses
      wrbbz
      eveeifyeve # Schema
      SchahinRohani
    ];
    mainProgram = "biome";
  };
})
