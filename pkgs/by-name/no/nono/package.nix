{
  lib,
  rustPlatform,
  fetchFromGitHub,

  pkg-config,

  dbus,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nono";
  version = "0.32.0";

  src = fetchFromGitHub {
    owner = "always-further";
    repo = "nono";
    tag = "v${finalAttrs.version}";
    hash = "sha256-OHzSkTqbYpXVH2czLsr04FlrKxF3E4KhqoPChQ2xcZM=";
  };

  cargoHash = "sha256-aMt0Rabx52Hl27TrZmA+KLSm6n4c2adlnY3ikoql8OU=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    dbus
  ];

  preCheck = ''
    # The Nix sandbox sets TMPDIR outside /tmp, tests that nest HOME under a tempdir would no longer be nested under /tmp, failing policy assertions.
    export TMPDIR=/tmp
    
  '';

  meta = {
    description = "Secure, kernel-enforced sandbox for AI agents, MCP and LLM workloads";
    homepage = "https://github.com/always-further/nono";
    changelog = "https://github.com/always-further/nono/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      jk
    ];
    mainProgram = "nono";
    # https://github.com/always-further/nono#platform-support
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
