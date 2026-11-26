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
  version = "2.5.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "yazeed";
    repo = "proc-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-msIAhJOSD2tEXkqQD4+Bj11yiR4q6ShHkbsbtC0S23Q=";
  };

  cargoHash = "sha256-WbluSwCzU+gQnQ3rAR2LGG4/DyeTnb6UEfzOLNsX0Rk=";

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

  # The port tests listen on 127.0.0.1, which the macOS sandbox refuses
  # (EPERM) without this
  __darwinAllowLocalNetworking = true;

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
    platforms =
      lib.platforms.linux ++ lib.platforms.darwin ++ lib.platforms.freebsd ++ lib.platforms.netbsd;
  };
})
