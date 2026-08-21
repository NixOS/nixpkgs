{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
  nixosTests,
}:

buildGoModule (finalAttrs: {
  pname = "cliproxyapi";
  version = "7.2.137";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "router-for-me";
    repo = "CLIProxyAPI";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8YipHopQcbr+mw8c34o8EArgzDJtIXu88fF6PBlGGyU=";
  };

  vendorHash = "sha256-CrDp7MOr+AwJUhTovklXx3F1yaktQlvD7VYhYSY6VvY=";

  subPackages = [ "cmd/server" ];

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${finalAttrs.version}"
    "-X main.Commit=v${finalAttrs.version}"
    "-X main.BuildDate=1970-01-01"
  ];

  postInstall = ''
    mv $out/bin/server $out/bin/cli-proxy-api
    ln -s $out/bin/cli-proxy-api $out/bin/cliproxyapi
    install -Dm444 config.example.yaml $out/share/doc/cliproxyapi/config.example.yaml
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
    tests = {
      inherit (nixosTests) cliproxyapi;
    };
  };

  meta = {
    description = "Proxy server providing OpenAI/Gemini/Claude/Codex/Grok compatible API interfaces for CLI models";
    homepage = "https://github.com/router-for-me/CLIProxyAPI";
    changelog = "https://github.com/router-for-me/CLIProxyAPI/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ rachalaraj ];
    mainProgram = "cli-proxy-api";
  };
})
