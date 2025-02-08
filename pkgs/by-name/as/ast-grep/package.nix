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
  version = "0.34.4";

  src = fetchFromGitHub {
    owner = "ast-grep";
    repo = "ast-grep";
    tag = version;
    hash = "sha256-fS2zuL0j/4Z24wvRIu2M47CafC/f0Ta3rMmQomB3P1Q=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-b0t5t7qla4/xZiR3YqhLUDRCj+V2jEUjY4sGGA7L+hE=";

  nativeBuildInputs = [ installShellFiles ];

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
