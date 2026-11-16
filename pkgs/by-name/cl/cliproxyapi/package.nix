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
  version = "8.0.71";

  src = fetchFromGitHub {
    owner = "router-for-me";
    repo = "CLIProxyAPI";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YPv0Dpyd0dH+snScByPaA/84us68BEKSrJ0MYjsuphE=";
  };

  vendorHash = "sha256-80mI9hXcDVaCmnbpq9PgfTUmLw/xZ8sWNpPJo5f1YJc=";

  subPackages = [ "cmd/server" ];

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${finalAttrs.version}"
    "-X main.Commit=v${finalAttrs.version}"
    "-X main.BuildDate=1970-01-01"
  ];

  __darwinAllowLocalNetworking = true;

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
    maintainers = with lib.maintainers; [
      anish
      moraxyc
    ];
    mainProgram = "cliproxyapi";
  };
})
