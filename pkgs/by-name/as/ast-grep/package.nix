{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  installShellFiles,
  versionCheckHook,
  nix-update-script,
  enableLegacySg ? false,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ast-grep";
  version = "0.38.5";

  src = fetchFromGitHub {
    owner = "ast-grep";
    repo = "ast-grep";
    tag = finalAttrs.version;
    hash = "sha256-yI3uAdP7x1zYMtRz4ppG4ySH/xmfQlnUlmJKoN/6Cw4=";
  };

  # error: linker `aarch64-linux-gnu-gcc` not found
  postPatch = ''
    rm .cargo/config.toml
  '';

  useFetchCargoVendor = true;
  cargoHash = "sha256-Idd/vrnj6XJYahmmHgGWPoMCmH7hkJFeWhV8YEo41rM=";

  nativeBuildInputs = [ installShellFiles ];

  cargoBuildFlags = [
    "--package ast-grep --bin ast-grep"
  ] ++ lib.optionals enableLegacySg [ "--package ast-grep --bin sg" ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd ast-grep \
      --bash <($out/bin/ast-grep completions bash) \
      --fish <($out/bin/ast-grep completions fish) \
      --zsh <($out/bin/ast-grep completions zsh)
    ${lib.optionalString enableLegacySg ''
      installShellCompletion --cmd sg \
        --bash <($out/bin/sg completions bash) \
        --fish <($out/bin/sg completions fish) \
        --zsh <($out/bin/sg completions zsh)
    ''}
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    mainProgram = "ast-grep";
    description = "Fast and polyglot tool for code searching, linting, rewriting at large scale";
    homepage = "https://ast-grep.github.io/";
    changelog = "https://github.com/ast-grep/ast-grep/blob/${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      xiaoxiangmoe
      montchr
      lord-valen
      cafkafk
    ];
  };
})
