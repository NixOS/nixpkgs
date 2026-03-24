{
  lib,
  rustPlatform,
  fetchFromGitHub,

  pkg-config,

  dbus,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nono";
  version = "0.23.0";

  src = fetchFromGitHub {
    owner = "always-further";
    repo = "nono";
    tag = "v${finalAttrs.version}";
    hash = "sha256-m88lr8nt6mgu0RrV5n66Rth9ja4Z9laut74lbXf6RJY=";
  };

  cargoHash = "sha256-l87Pn6zVZ8ZRPp6m7Aet5uc+5aVjKVbQsHvtaEuTTD8==";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    dbus
  ];

  preCheck = ''
    # Integration test env_nono_allow_comma_separated expects these paths to exist
    mkdir -p /tmp/a /tmp/b
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
