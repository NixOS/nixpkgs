{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule rec {
  pname = "certstream-server-go";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "d-Rickyy-b";
    repo = "certstream-server-go";
    tag = "v${version}";
    hash = "sha256-iA4kwhGvAkRL0cMCfo0mdQYUZbWk3Y8xdb7jjjTaRFM=";
  };

  vendorHash = "sha256-S5uF+i5Qsgi3M7B7LbO7CDO2GkWXn4X8wK/hgSSedHo=";

  ldflags = [
    "-s"
    "-w"
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Drop-in replacement in Golang for the certstream server by Calidog";
    homepage = "https://github.com/d-Rickyy-b/certstream-server-go";
    changelog = "https://github.com/d-Rickyy-b/certstream-server-go/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ x123 ];
    mainProgram = "certstream-server-go";
  };
}
