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
  version = "8.1.4";

  src = fetchFromGitHub {
    owner = "router-for-me";
    repo = "CLIProxyAPI";
    tag = "v${finalAttrs.version}";
    hash = "sha256-CVS+CVULKVRxAOaKunbIwDfEENPK9YX/zFXBAMIXN8c=";
  };

  vendorHash = "sha256-WUbMD30d1CU1KWFey8dIG0K/lO4TCObiuDJowITRwk8=";

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
