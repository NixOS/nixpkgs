{
  lib,
  fetchFromGitHub,
  buildGoModule,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "emcee";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "loopwork-ai";
    repo = "emcee";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ri/4Xxc6QgGqsARI5c2JjVeEe5lOmi/c+B3+vUvW6ow=";
  };

  vendorHash = "sha256-B8shxh1fLdIR7TN0mSugu9wFNShmrb1WBzCArHVVnoU=";

  ldflags = [
    "-X main.version=${finalAttrs.version}"
  ];

  __darwinAllowLocalNetworking = true;

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  versionCheckProgramArg = [ "--version" ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Connect agents to APIs";
    longDescription = ''
      emcee is a tool that provides a Model Context Protocol (MCP) server
      for any web application with an OpenAPI specification.
      You can use emcee to connect Claude Desktop
      and other apps to external tools and data services, similar to ChatGPT plugins.
    '';
    homepage = "https://github.com/loopwork-ai/emcee";
    changelog = "https://github.com/loopwork-ai/emcee/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ genga898 ];
    mainProgram = "emcee";
  };
})
