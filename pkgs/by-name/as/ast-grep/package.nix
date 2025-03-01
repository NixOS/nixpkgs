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
  version = "0.35.0";

  src = fetchFromGitHub {
    owner = "ast-grep";
    repo = "ast-grep";
    tag = version;
    hash = "sha256-uiQYqVcSSQT32Vu8iE5ATIHFGDiyuxaQvg8hkBtB4DU=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-B/egtLMBrlLobB1m04L1NlNmZ6+DdQIV9Ae0LVPmO2Y=";

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
