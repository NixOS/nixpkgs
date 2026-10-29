{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "reproxy";
  version = "1.7.2";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "umputun";
    repo = "reproxy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GIvOiszOrdUCOWT6QZT7Dak5x0B84gaJtf9K/7CwxIo=";
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
    changelog = "https://github.com/umputun/reproxy/releases/tag/${finalAttrs.src.rev}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sikmir ];
    mainProgram = "reproxy";
  };
})
