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
    rev = "f5902cd08e6eb396d148b7cb69cef8d3c7fe7ba7";
    hash = "sha256-Aab/MtXtAShkH4toQfD2w1tc9kdqXcGjM0/N6HI27TI=";
  };
  npmDepsHash = "sha256-bKR7jDF/FYnKvsD77oseqHq/UHg5nRHiPoTxbUOkwNk=";

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
