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
  version = "0.45.1";

  src = fetchFromGitHub {
    owner = "ast-grep";
    repo = "ast-grep";
    tag = finalAttrs.version;
    hash = "sha256-YNn49WuILwe3gyvHSKh3dH5BZKhtR+YeSCCGDu0qulg=";
  };

  # error: linker `aarch64-linux-gnu-gcc` not found
  postPatch = ''
    rm .cargo/config.toml
  '';

  cargoHash = "sha256-6ZqV9SJes6++TJxcj/Dmi8DyaoTa164CKi4C/EyfnuQ=";

  nativeBuildInputs = [ installShellFiles ];

  cargoBuildFlags = [
    "--package ast-grep --bin ast-grep"
  ]
  ++ lib.optionals enableLegacySg [ "--package ast-grep --bin sg" ];

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
      astratagem
      lord-valen
      cafkafk
    ];
  };
})
