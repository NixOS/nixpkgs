{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  procps,
  darwin,
  lsof,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "proc-cli";
  version = "2.1.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "yazeed";
    repo = "proc-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pPBnEbnclCuDd6y5W+MNocDiFt2slHJNL/efRZsZEkQ=";
  };

  cargoHash = "sha256-wqcsOLce7ZYCObjSaDRDeA/CtSuNsTL2jAkPGDCQl+Q=";

  nativeBuildInputs = [ installShellFiles ];

  # The sandbox's PATH has only the build inputs. The tests run `ps` (Linux:
  # procps; macOS: Apple's ps), and on macOS proc reads ports with `lsof`
  nativeCheckInputs =
    lib.optionals stdenv.hostPlatform.isLinux [ procps ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      darwin.ps
      lsof
    ];

  # The pseudo-terminal tests start proc in $HOME (portable-pty's default
  # working directory), and the sandbox's HOME does not exist
  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    $out/bin/proc manpage > proc.1
    installManPage proc.1
    installShellCompletion --cmd proc \
      --bash <($out/bin/proc completions bash) \
      --zsh <($out/bin/proc completions zsh) \
      --fish <($out/bin/proc completions fish)
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Semantic CLI tool for process management. Target by port, PID, name or path";
    homepage = "https://proc-cli.com";
    changelog = "https://github.com/yazeed/proc-cli/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    mainProgram = "proc";
    maintainers = with lib.maintainers; [ yazeed ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
