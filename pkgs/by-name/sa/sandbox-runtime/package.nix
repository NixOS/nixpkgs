{
  lib,
  stdenv,
  fetchFromGitHub,
  buildNpmPackage,
  ripgrep,
  bubblewrap,
  socat,
}:

buildNpmPackage (finalAttrs: {
  pname = "sandbox-runtime";
  version = "unstable-2025-11-29";

  src = fetchFromGitHub {
    owner = "anthropic-experimental";
    repo = "sandbox-runtime";
    rev = "c1d8292f3f39094ddaa2e8dd29ac373349b31d09";
    hash = "sha256-DAWl7HdhRiGau+zZhNI9DbQy0fxt5v4eAvfHalkQGNI=";
  };
  npmDepsHash = "sha256-E7IiqGkACvxtAcjzo6kK47cLMk7rH9k7ANjgJkZ9Mng=";

  buildInputs = [
    ripgrep
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    bubblewrap
    socat
  ];

  meta = {
    description = ''
      A lightweight sandboxing tool for enforcing filesystem and network restrictions on arbitrary processes at the OS level, without requiring a container.

      srt uses native OS sandboxing primitives (sandbox-exec on macOS, bubblewrap on Linux) and proxy-based network filtering. It can be used to sandbox the behaviour of agents, local MCP servers, bash commands and arbitrary processes.'';
    homepage = "https://github.com/anthropic-experimental/sandbox-runtime";
    license = lib.licenses.asl20;
    maintainers = [ ];
    mainProgram = "srt";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
