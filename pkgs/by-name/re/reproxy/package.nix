{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "reproxy";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "umputun";
    repo = "reproxy";
    rev = "v${version}";
    hash = "sha256-UQ20mP+7AsrkNN+tvaRb8BcpHu76bpmswtR2PL4/JsE=";
  };

  vendorHash = null;

  ldflags = [
    "-s" "-w" "-X main.revision=${version}"
  ];

  checkFlags = [
    # Requires network access or fluky
    "-skip=^Test(_MainWithPlugin|_MainWithSSL|_Main|Http_health|Http_matchHandler|Http_withBasicAuth|File_Events|File_Events_BusyListener)$"
  ];

  postInstall = ''
    mv $out/bin/{app,reproxy}
  '';

  meta = with lib; {
    description = "Simple edge server / reverse proxy";
    homepage = "https://reproxy.io/";
    changelog = "https://github.com/umputun/reproxy/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ sikmir ];
    mainProgram = "reproxy";
  };
}
