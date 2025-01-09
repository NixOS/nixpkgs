{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,

  rust-jemalloc-sys,
  buildPackages,
  versionCheckHook,

  # passthru
  ruff-lsp,
  nixosTests,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "ruff";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "astral-sh";
    repo = "ruff";
    tag = version;
    hash = "sha256-OAhjatPzwvLT3HyXYPzaL5pAC5CH75CyMmFo0c4726I=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-vroKiwouk2E2WYB/B+8zszXqer5pENDYrxcrCQ17mF0=";

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = [
    rust-jemalloc-sys
  ];

  postInstall =
    let
      emulator = stdenv.hostPlatform.emulator buildPackages;
    in
    ''
      installShellCompletion --cmd ruff \
        --bash <(${emulator} $out/bin/ruff generate-shell-completion bash) \
        --fish <(${emulator} $out/bin/ruff generate-shell-completion fish) \
        --zsh <(${emulator} $out/bin/ruff generate-shell-completion zsh)
    '';

  # Run cargo tests
  checkType = "debug";

  # tests do not appear to respect linker options on doctests
  # Upstream issue: https://github.com/rust-lang/cargo/issues/14189
  # This causes errors like "error: linker `cc` not found" on static builds
  postInstallCheck = lib.optionalString (!stdenv.hostPlatform.isStatic) ''
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

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = [ "--version" ];
  doInstallCheck = true;

  passthru = {
    tests =
      {
        inherit ruff-lsp;
      }
      // lib.optionalAttrs stdenv.hostPlatform.isLinux {
        nixos-test-driver-busybox = nixosTests.nixos-test-driver.busybox;
      };
    updateScript = nix-update-script { };
  };

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
