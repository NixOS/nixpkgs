{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "reproxy";
  version = "1.2.3";

  src = fetchFromGitHub {
    owner = "umputun";
    repo = "reproxy";
    tag = "v${version}";
    hash = "sha256-u2hS06UOu+YYEB03Xtvxg1XJx2FO3AqxCsCnR8YfFj4=";
  };

  vendorHash = null;

  ldflags = [
    "-s"
    "-w"
    "-X main.revision=${version}"
  ];

  checkFlags = [
    # Requires network access or fluky
    "-skip=^Test(_MainWithPlugin|_MainWithSSL|_Main|Http_health|Http_matchHandler|Http_withBasicAuth|File_Events|File_Events_BusyListener)$"
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
