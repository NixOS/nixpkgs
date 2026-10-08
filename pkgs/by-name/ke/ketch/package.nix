{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "ketch";
  version = "0.18.1";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "1broseidon";
    repo = "ketch";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vXSYQJBZ0Eypy3S0qvJUEEk9SZnnIWmQ5DU3TGyuwfk=";
  };

  vendorHash = "sha256-NqZlxCbXfH4OJQGEVQwA6uu5LLlKDmwGYDRM6V8U/+4=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/1broseidon/ketch/cmd.version=${finalAttrs.version}"
  ];

  # fixes failing test https://github.com/1broseidon/ketch/blob/3722f58c1ff5c6b14b687ca3f925587996033536/cmd/config_golden_test.go#L33
  # precedent: https://github.com/NixOS/nixpkgs/blob/bbc4e5521d1a4c19312d0ada5ac3e5c214ea0fa0/pkgs/by-name/gr/grype/package.nix#L80
  preCheck = ''
    unset ldflags
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Fast, stateless CLI for web search and scrape. Built for AI agents.";
    homepage = "https://chain.sh/ketch/";
    changelog = "https://github.com/1broseidon/ketch/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      stephsi
    ];
    mainProgram = "ketch";
  };
})
