{
  lib,
  fetchFromGitHub,
  rustPlatform,
  installShellFiles,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  # Originally, this package was under the attribute `du-dust`, since `dust` was taken.
  # Since then, `dust` has been freed up, allowing this package to take that attribute.
  # However in order for tools like `nix-env` to detect package updates, keep `du-dust` for pname.
  pname = "du-dust";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "bootandy";
    repo = "dust";
    tag = "v${finalAttrs.version}";
    hash = "sha256-tj+prO7KZrw0lrZahbw0c8TcfNrIc1Z08Tm1MHpOFLM=";
    # Remove unicode file names which leads to different checksums on HFS+
    # vs. other filesystems because of unicode normalisation.
    postFetch = ''
      rm -r $out/tests/test_dir_unicode/
    '';
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-1pKk41dQlcrPzJ01uvo87G9iTDiBq9XHGOoZ0OH4Mls=";

  nativeBuildInputs = [ installShellFiles ];

  checkFlags = [
    # disable tests that depend on the unicode files we removed above
    "--skip=test_show_files_by_type"
  ];

  preCheck = ''
    # These tests depend on the disk format of the build host.
    rm tests/test_exact_output.rs
    rm tests/tests_symlinks.rs
  '';

  postInstall = ''
    installManPage man-page/dust.1
    installShellCompletion completions/dust.{bash,fish} --zsh completions/_dust
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgram = "${placeholder "out"}/bin/dust";
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "du + rust = dust. Like du but more intuitive";
    homepage = "https://github.com/bootandy/dust";
    changelog = "https://github.com/bootandy/dust/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      aaronjheng
      defelo
    ];
    mainProgram = "dust";
  };
})
