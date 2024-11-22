{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  stdenv,
  python3Packages,
  darwin,
  rust-jemalloc-sys,
  ruff-lsp,
  nix-update-script,
  versionCheckHook,
  libiconv,
}:

python3Packages.buildPythonPackage rec {
  pname = "ruff";
  version = "0.7.4";
  pyproject = true;

  outputs = [
    "bin"
    "out"
  ];

  src = fetchFromGitHub {
    owner = "astral-sh";
    repo = "ruff";
    rev = "refs/tags/${version}";
    hash = "sha256-viDjUfj/OWYU7Fa7mqD2gYoirKFSaTXPPi0iS7ibiiU=";
  };

  # Do not rely on path lookup at runtime to find the ruff binary
  postPatch = ''
    substituteInPlace python/ruff/__main__.py \
      --replace-fail \
        'ruff_exe = "ruff" + sysconfig.get_config_var("EXE")' \
        'return "${placeholder "bin"}/bin/ruff"'
  '';

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "lsp-types-0.95.1" = "sha256-8Oh299exWXVi6A39pALOISNfp8XBya8z+KT/Z7suRxQ=";
      "salsa-0.18.0" = "sha256-zUF2ZBorJzgo8O8ZEnFaitAvWXqNwtHSqx4JE8nByIg=";
    };
  };

  nativeBuildInputs =
    [ installShellFiles ]
    ++ (with rustPlatform; [
      cargoSetupHook
      maturinBuildHook
      cargoCheckHook
    ]);

  buildInputs =
    [
      rust-jemalloc-sys
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      darwin.apple_sdk.frameworks.CoreServices
      libiconv
    ];

  postInstall =
    ''
      mkdir -p $bin/bin
      mv $out/bin/ruff $bin/bin/
      rmdir $out/bin
    ''
    + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
      installShellCompletion --cmd ruff \
        --bash <($bin/bin/ruff generate-shell-completion bash) \
        --fish <($bin/bin/ruff generate-shell-completion fish) \
        --zsh <($bin/bin/ruff generate-shell-completion zsh)
    '';

  passthru = {
    tests = {
      inherit ruff-lsp;
    };
    updateScript = nix-update-script { };
  };

  # Run cargo tests
  cargoCheckType = "debug";
  postInstallCheck = ''
    cargoCheckHook
  '';

  # Failing on darwin for an unclear reason.
  # According to the maintainers, those tests are from an experimental crate that isn't actually
  # used by ruff currently and can thus be safely skipped.
  checkFlags = lib.optionals stdenv.hostPlatform.isDarwin [
    "--skip=add_search_path"
    "--skip=changed_file"
    "--skip=changed_versions_file"
    "--skip=deleted_file"
    "--skip=directory_deleted"
    "--skip=directory_moved_to_trash"
    "--skip=directory_moved_to_workspace"
    "--skip=directory_renamed"
    "--skip=hard_links_in_workspace"
    "--skip=hard_links_to_target_outside_workspace"
    "--skip=move_file_to_trash"
    "--skip=move_file_to_workspace"
    "--skip=new_file"
    "--skip=new_ignored_file"
    "--skip=rename_file"
    "--skip=search_path"
    "--skip=unix::changed_metadata"
    "--skip=unix::symlink_inside_workspace"
    "--skip=unix::symlinked_module_search_path"
  ];

  nativeCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = [ "--version" ];

  pythonImportsCheck = [ "ruff" ];

  meta = {
    description = "Extremely fast Python linter";
    homepage = "https://github.com/astral-sh/ruff";
    changelog = "https://github.com/astral-sh/ruff/releases/tag/${version}";
    license = lib.licenses.mit;
    mainProgram = "ruff";
    maintainers = with lib.maintainers; [
      figsoda
      GaetanLepage
    ];
  };
}
