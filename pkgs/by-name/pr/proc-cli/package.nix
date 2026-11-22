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
  version = "2.4.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "yazeed";
    repo = "proc-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pG3kioWjEI9AQ1D+lHW2xtwQCUqerpdMCizx3gG2SPs=";
  };

  cargoHash = "sha256-Eg+86S2XuitFh5UA3wh7p3kTEnqwWuiR2UnsR+TAzXs=";

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
