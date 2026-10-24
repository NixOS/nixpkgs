{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  nixosTests,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  __structuredAttrs = true;

  pname = "cliproxyapi";
  version = "8.0.41";

  src = fetchFromGitHub {
    owner = "router-for-me";
    repo = "CLIProxyAPI";
    tag = "v${finalAttrs.version}";
    hash = "sha256-arwHtMDM3OqPGnZmef2qsDqqKjvhJikG/5JLFZ6CCF8=";
  };

  vendorHash = "sha256-yMO0DdE0pjtFxWaQXV17enV8u0KA5fIUbE8Gui/RvWU=";

  subPackages = [ "cmd/server" ];

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${finalAttrs.version}"
    "-X main.Commit=v${finalAttrs.version}"
    "-X main.BuildDate=1970-01-01"
  ];

  postInstall = ''
    mv $out/bin/server $out/bin/cliproxyapi
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru = {
    tests = { inherit (nixosTests) cliproxyapi; };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Proxy that provides OpenAI/Gemini/Claude/Codex/Grok compatible API interfaces";
    homepage = "https://github.com/router-for-me/CLIProxyAPI";
    changelog = "https://github.com/router-for-me/CLIProxyAPI/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ anish ];
    mainProgram = "cliproxyapi";
  };
})
