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
  nixosTests,
}:

python3Packages.buildPythonPackage rec {
  pname = "ruff";
  version = "0.8.0";
  pyproject = true;

  outputs = [
    "bin"
    "out"
  ];

  src = fetchFromGitHub {
    owner = "astral-sh";
    repo = "ruff";
    rev = "refs/tags/${version}";
    hash = "sha256-yenGZ7TuiHtY/3AIjMPlHVtQPP6PHMc1wdezfZdVtK0=";
  };

  # Do not rely on path lookup at runtime to find the ruff binary
  postPatch = ''
    substituteInPlace python/ruff/__main__.py \
      --replace-fail \
        'ruff_exe = "ruff" + sysconfig.get_config_var("EXE")' \
        'return "${placeholder "bin"}/bin/ruff"'
  '';

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-O5+uVYWtSMEj7hBrc/FUuqRBN4hUlEbtDPF42kpL7PA=";
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
      nixos-test-driver-busybox = nixosTests.nixos-test-driver.busybox;
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
    "--skip=added_package"
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
    "--skip=nested_packages_delete_root"
    "--skip=new_file"
    "--skip=new_ignored_file"
    "--skip=removed_package"
    "--skip=rename_file"
    "--skip=search_path"
    "--skip=unix::changed_metadata"
    "--skip=unix::symlinked_module_search_path"
    "--skip=unix::symlink_inside_workspace"
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
