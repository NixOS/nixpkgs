{
  lib,
  buildGo127Module,
  fetchFromGitHub,
  installShellFiles,
  versionCheckHook,
}:

buildGo127Module (finalAttrs: {
  pname = "reproxy";
  version = "1.7.5";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "umputun";
    repo = "reproxy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-g8oV8taxmnL9Pkx9Pq6+aJA2z22CDNa7rRdpbWOvU1c=";
  };

  vendorHash = null;

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s"
    "-X main.revision=${finalAttrs.version}"
  ];

  checkFlags = [
    # Requires network access or fluky
    "-skip=^Test(_MainWithPlugin|_MainWithSSL|_Main|Http_DoWithRedirects|Http_health|Http_matchHandler|Http_withBasicAuth|File_Events|File_Events_BusyListener|Service_ScheduleHealthCheck)$"
  ];

  postInstall = ''
    mv $out/bin/{app,reproxy}
    installShellCompletion completions/*
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Simple edge server / reverse proxy";
    homepage = "https://reproxy.io/";
    changelog = "https://github.com/umputun/reproxy/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sikmir ];
    mainProgram = "reproxy";
  };
})
