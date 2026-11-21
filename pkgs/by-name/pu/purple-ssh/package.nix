{
  fetchFromGitHub,
  installShellFiles,
  lib,
  makeWrapper,
  nix-update-script,
  openssh,
  openssl,
  pkg-config,
  rustPlatform,
  stdenv,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "purple-ssh";
  version = "3.34.2";

  __structuredAttrs = true;
  # mockito's tests bind a local socket.
  __darwinAllowLocalNetworking = true;

  src = fetchFromGitHub {
    owner = "erickochen";
    repo = "purple";
    tag = "v${finalAttrs.version}";
    hash = "sha256-om3KNppxM7c3hcc/tGkXcRTrZMX6ft8PAqU9m2zGcog=";
  };

  cargoHash = "sha256-Oq6LN3wzSO5vdbYJ82q6RlfgJtbtYC8BIWVXjmkf0N8=";

  nativeBuildInputs = [
    installShellFiles
    makeWrapper
    pkg-config
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ openssl ];

  # Only musl builds vendor OpenSSL upstream; use the system one here.
  env.OPENSSL_NO_VENDOR = 1;

  nativeCheckInputs = [
    openssh
    writableTmpDirAsHomeHook
  ];

  checkFlags = [
    # Assumes /bin/sh is not bash: in the sandbox, bash prefixes the wrapped
    # run's error with "line 0:", so it differs from the plain run.
    "--skip=snippet::tests::test_wrap_interactive_runs_plainly_on_other_login_shells"
    # Hardcodes PATH=/usr/bin:/bin:/usr/local/bin and expects ssh there.
    "--skip=a_host_ssh_reports_as_direct_is_answered_on_a_prompt_it_cannot_place"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd purple \
      --bash <($out/bin/purple --completions bash) \
      --fish <($out/bin/purple --completions fish) \
      --zsh <($out/bin/purple --completions zsh)
  '';

  # ssh, scp, ssh-keygen and ssh-add are used for every core action and are a
  # declared runtime dependency upstream. tmux, lsof, container runtimes,
  # vault and cloud CLIs stay user-provided.
  postFixup = ''
    wrapProgram $out/bin/purple --prefix PATH : ${lib.makeBinPath [ openssh ]}
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Terminal SSH manager and SSH config editor";
    homepage = "https://getpurple.sh";
    license = lib.licenses.mit;
    mainProgram = "purple";
    maintainers = [ lib.maintainers.lukasgierth ];
    platforms = lib.platforms.unix;
  };
})
