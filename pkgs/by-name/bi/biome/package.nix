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
  version = "2.6.5";

  src = fetchFromGitHub {
    owner = "biomejs";
    repo = "biome";
    rev = "@biomejs/biome@${finalAttrs.version}";
    hash = "sha256-ogWvhY1SRYIu1llSGWtuGSVKDG6Vhs6YmLO6aembjvw=";
  };

  cargoHash = "sha256-8d9he9/GMsGvoZnTexpMzsuEczgwOVB/3OmvU8Pq+Us=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libgit2
    rust-jemalloc-sys
    zlib
  ];

  nativeCheckInputs = [ gitMinimal ];

  # tests spin up a local HTTP server on 127.0.0.1
  __darwinAllowLocalNetworking = true;

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
    # cargo test builds the lib, bin and integration test targets with fat LTO
    # in parallel, each taking ~8-10G of RAM, which OOMs builders with 32G
    export NIX_BUILD_CORES=$(( NIX_BUILD_CORES > 2 ? 2 : NIX_BUILD_CORES ))

    # without a usable cache dir biome falls back to $TMPDIR (/build), and the
    # snapshot redactor then mangles any "/build" in test output
    export XDG_CACHE_HOME="$TMPDIR/xdg-cache"

    # tests assume git repository
    git init

    # tests assume $BIOME_VERSION is unset
    unset BIOME_VERSION
  '';

  passthru = {
    updateScript = nix-update-script { };
    jsonschema = "${finalAttrs.finalPackage}/share/schema.json";
  };

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
