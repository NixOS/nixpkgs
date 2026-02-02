{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "cagent";
  version = "1.20.0";

  src = fetchFromGitHub {
    owner = "docker";
    repo = "cagent";
    tag = "v${finalAttrs.version}";
    hash = "sha256-HOQibgT9R7Ic1tGtgjSB+nSWKID6TD1Yt6tr37Voa7w=";
  };

  vendorHash = "sha256-8NXiIxaq+03+LrHFBaxZ4YFb0sqYikajgk5gYXTn3Rs=";

  # Disable tests: Networked model providers and writable cache directories are required.
  doCheck = false;

  # Skip install checks on macOS: The build sandbox is missing the `/etc/protocols` file, which is required for validation.
  doInstallCheck = !stdenv.hostPlatform.isDarwin;

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "version";

  ldflags = [
    "-s"
    "-w"
    "-X"
    "github.com/docker/cagent/pkg/version.Version=${finalAttrs.version}"
    "-X"
    "github.com/docker/cagent/pkg/version.Commit=${finalAttrs.src.tag}"
  ];

  meta = {
    description = "Agent Builder and Runtime by Docker Engineering";
    longDescription = ''
      A powerful, easy-to-use, customizable multi-agent runtime that
      orchestrates AI agents with specialized capabilities and tools,
      and the interactions between agents.
    '';
    homepage = "https://github.com/docker/cagent";
    changelog = "https://github.com/docker/cagent/releases/tag/v${finalAttrs.version}";
    downloadPage = "https://github.com/docker/cagent/releases";
    license = lib.licenses.asl20;
    mainProgram = "cagent";
    maintainers = with lib.maintainers; [ MH0386 ];
  };
})
