{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  installShellFiles,
  buildPackages,
  versionCheckHook,
  nix-update-script,
  enableLegacySg ? false,
}:

rustPlatform.buildRustPackage rec {
  pname = "ast-grep";
  version = "0.33.1";

  src = fetchFromGitHub {
    owner = "ast-grep";
    repo = "ast-grep";
    tag = version;
    hash = "sha256-p7SJhkCoo4jBDyr+Z2+qxjUwWXWpVMuXd2/DDOM7Z/Q=";
  };

  cargoHash = "sha256-aCBEL+Jx4Kk7PWsxIgpdRdI7AnUAUEtRU4+JMxQ4Swk=";

  nativeBuildInputs = [ installShellFiles ];

  # error: linker `aarch64-linux-gnu-gcc` not found
  postPatch = ''
    rm .cargo/config.toml
  '';

  cargoBuildFlags = [
    "--package ast-grep --bin ast-grep"
  ] ++ lib.optionals enableLegacySg [ "--package ast-grep --bin sg" ];

  postInstall = lib.optionalString (stdenv.hostPlatform.emulatorAvailable buildPackages) (
    let
      emulator = stdenv.hostPlatform.emulator buildPackages;
    in
    ''
      installShellCompletion --cmd ast-grep \
        --bash <(${emulator} $out/bin/ast-grep completions bash) \
        --fish <(${emulator} $out/bin/ast-grep completions fish) \
        --zsh <(${emulator} $out/bin/ast-grep completions zsh)
    ''
    + lib.optionalString enableLegacySg ''
      installShellCompletion --cmd sg \
        --bash <(${emulator} $out/bin/sg completions bash) \
        --fish <(${emulator} $out/bin/sg completions fish) \
        --zsh <(${emulator} $out/bin/sg completions zsh)
    ''
  );

  checkFlags =
    [
      # disable flaky test
      "--skip=test::test_load_parser_mac"

      # BUG: Broke by 0.12.1 update (https://github.com/NixOS/nixpkgs/pull/257385)
      # Please check if this is fixed in future updates of the package
      "--skip=verify::test_case::tests::test_unmatching_id"
    ]
    ++ lib.optionals (with stdenv.hostPlatform; (isDarwin && isx86_64) || (isLinux && isAarch64)) [
      # x86_64-darwin: source/benches/fixtures/json-mac.so\' (no such file), \'/private/tmp/nix-build-.../source/benches/fixtures/json-mac.so\' (mach-o file, but is an incompatible architecture (have \'arm64\', need \'x86_64h\' or \'x86_64\'))" })
      # aarch64-linux: /build/source/benches/fixtures/json-linux.so: cannot open shared object file: No such file or directory"
      "--skip=test::test_load_parser"
      "--skip=test::test_register_lang"
    ];
  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = [ "--version" ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    mainProgram = "ast-grep";
    description = "Fast and polyglot tool for code searching, linting, rewriting at large scale";
    homepage = "https://ast-grep.github.io/";
    changelog = "https://github.com/ast-grep/ast-grep/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      xiaoxiangmoe
      montchr
      lord-valen
      cafkafk
    ];
  };
}
