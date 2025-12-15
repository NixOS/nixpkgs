{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "reproxy";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "umputun";
    repo = "reproxy";
    tag = "v${version}";
    hash = "sha256-zpfgwlGYXe7I3yO8Cc53ZrPDpXn8hk6cOcXwWyxub+A=";
  };

  vendorHash = null;

  ldflags = [
    "-s"
    "-w"
    "-X main.revision=${version}"
  ];

  checkFlags = [
    # Requires network access or fluky
    "-skip=^Test(_MainWithPlugin|_MainWithSSL|_Main|Http_DoWithRedirects|Http_health|Http_matchHandler|Http_withBasicAuth|File_Events|File_Events_BusyListener|Service_ScheduleHealthCheck)$"
  ];

  postInstall = ''
    mv $out/bin/{app,reproxy}
  '';

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Simple edge server / reverse proxy";
    homepage = "https://reproxy.io/";
    changelog = "https://github.com/umputun/reproxy/releases/tag/${src.rev}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sikmir ];
    mainProgram = "reproxy";
  };
}
