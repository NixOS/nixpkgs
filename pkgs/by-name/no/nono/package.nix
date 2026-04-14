{
  lib,
  rustPlatform,
  fetchFromGitHub,

  pkg-config,

  dbus,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nono";
  version = "0.35.0";

  src = fetchFromGitHub {
    owner = "always-further";
    repo = "nono";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/bKquUbVMM1e/YPcuSb0vW4tX/3yNDUxmaBWHKFw+Qs=";
  };
  cargoHash = "sha256-ibGIpH6Ls9nxtF6rRl+dZBbbmVRXDQA6vpPI/jzpDqI=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    dbus
  ];

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
