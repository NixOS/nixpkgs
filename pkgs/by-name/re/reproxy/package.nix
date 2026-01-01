{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "reproxy";
<<<<<<< HEAD
  version = "1.3.0";
=======
  version = "1.2.3";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "umputun";
    repo = "reproxy";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-zpfgwlGYXe7I3yO8Cc53ZrPDpXn8hk6cOcXwWyxub+A=";
=======
    hash = "sha256-u2hS06UOu+YYEB03Xtvxg1XJx2FO3AqxCsCnR8YfFj4=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
