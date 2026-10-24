{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  versionCheckHook,
  nix-update-script,
  pkg-config,
  pkl,
  python3,
  libgit2,
  openssl,
  cacert,
  gitMinimal,
  writableTmpDirAsHomeHook,
  runCommand,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "hk";
  version = "2.8.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "jdx";
    repo = "hk";
    tag = "v${finalAttrs.version}";
    hash = "sha256-LTF9bklF2bqqhTpgXQ/SSeZuoWALTOXXi3bmBvX0PHM=";
  };

  cargoHash = "sha256-l7BJvy4jtJAoNIVFCLZnPxqA6W6lPAHhXbY4j9E3eNo=";

  nativeBuildInputs = [
    installShellFiles
    pkg-config
    pkl
    python3
  ];

  buildInputs = [
    libgit2
    openssl
  ];

  # Generate Builtins.pkl and metadata missing from the source archive
  preBuild = ''
    python3 scripts/gen_builtins.py
  '';

  env = {
    HK_REQUIRE_EMBEDDED_PKL = "1";
    LIBGIT2_NO_VENDOR = 1;
  };

  nativeCheckInputs = [
    # reqwest needs a CA bundle even for local Pkl modules
    cacert
    # Some tests build fixture repositories by shelling out to git
    gitMinimal
    writableTmpDirAsHomeHook
  ];

  preCheck = ''
    # Some tests expect to run in a Git repo
    git init --quiet
  '';

  # Pkl HTTP tests bind to localhost
  __darwinAllowLocalNetworking = true;

  cargoBuildFlags = [
    "--bin"
    "hk"
  ];

  cargoTestFlags = [ "--all-features" ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  # Generate completions after patchelf to avoid ETXTBSY
  postFixup = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd hk \
      --bash <($out/bin/hk completion bash) \
      --fish <($out/bin/hk completion fish) \
      --zsh <($out/bin/hk completion zsh)
  '';

  passthru = {
    updateScript = nix-update-script { };
    tests.init =
      runCommand "hk-init"
        {
          nativeBuildInputs = [
            finalAttrs.finalPackage
            cacert
            gitMinimal
            writableTmpDirAsHomeHook
          ];
        }
        ''
          export HK_PKL_OFFLINE=1
          export HK_PKL_CACHE_DIR="$TMPDIR/pkl-cache"

          mkdir repo
          cd repo
          git init --quiet
          echo '{}' > biome.jsonc

          hk init
          grep -F 'Builtins.biome' hk.pkl
          hk validate

          touch "$out"
        '';
  };

  meta = {
    description = "Tool for managing git hooks";
    homepage = "https://hk.jdx.dev";
    changelog = "https://github.com/jdx/hk/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      typedrat
      Br1ght0ne
      sshine
    ];
    mainProgram = "hk";
  };
})
