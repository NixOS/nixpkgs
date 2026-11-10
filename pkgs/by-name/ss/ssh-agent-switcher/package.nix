{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  openssh,
  shtk,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ssh-agent-switcher";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "jmmv";
    repo = "ssh-agent-switcher";
    tag = "ssh-agent-switcher-${finalAttrs.version}";
    hash = "sha256-XAIupGVU8D4tmZXZ3/5lKiHbvBlxgNQXL0T9Htp7Zmo=";
  };

  cargoHash = "sha256-dbeUye20E2nQcJPyUCpZT68T95dopgoIlBm8rOoaZ6Y=";

  nativeBuildInputs = [
    installShellFiles
    shtk.dev
  ];

  nativeCheckInputs = [ openssh ];

  checkPhase = ''
    runHook preCheck

    cargoCheckHook

    shtk build -m shtk_unittest_main -o inttest inttest.sh
    MODE="${stdenv.hostPlatform.rust.rustcTarget}/release" ./inttest

    runHook postCheck
  '';

  postInstall = ''
    installManPage ssh-agent-switcher.1

    install -Dm644 README.md -t $out/share/doc/ssh-agent-switcher/
    install -Dm644 NEWS.md -t $out/share/doc/ssh-agent-switcher/
    install -Dm644 COPYING -t $out/share/doc/ssh-agent-switcher/
  '';

  meta = {
    description = "SSH agent forwarding and tmux done right";
    longDescription = ''
      ssh-agent-switcher is a daemon that proxies SSH agent connections to any
      valid forwarded agent provided by sshd. This allows long-lived processes
      such as terminal multiplexers like tmux or screen to access the
      connection-specific forwarded agents.
    '';
    homepage = "https://github.com/jmmv/ssh-agent-switcher";
    changelog = "https://github.com/jmmv/ssh-agent-switcher/blob/ssh-agent-switcher-${finalAttrs.version}/NEWS.md";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.jmmv ];
    mainProgram = "ssh-agent-switcher";
    platforms = lib.platforms.unix;
  };
})
