{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  openssh,
  shtk,
}:

rustPlatform.buildRustPackage rec {
  pname = "ssh-agent-switcher";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "jmmv";
    repo = "ssh-agent-switcher";
    tag = "ssh-agent-switcher-${version}";
    hash = "sha256-p9W0H25pWDB+GCrwLwuVruX9p8b8kICpp+6I11ym1aw=";
  };

  cargoHash = "sha256-WioA/RjXOAHM9QWl/lxnb7gqzcp76rus7Rv+IfCYceg=";

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
    changelog = "https://github.com/jmmv/ssh-agent-switcher/blob/ssh-agent-switcher-${version}/NEWS.md";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.jmmv ];
    mainProgram = "ssh-agent-switcher";
    platforms = lib.platforms.unix;
  };
}
