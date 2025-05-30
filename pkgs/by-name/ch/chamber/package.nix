{
  buildGoModule,
  lib,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "chamber";
  version = "3.1.2";

  src = fetchFromGitHub {
    owner = "segmentio";
    repo = "chamber";
    rev = "v${version}";
    sha256 = "sha256-9+I/zH4sHlLQkEn+fCboI3vCjYjlk+hdYnWuxq47r5I=";
  };

  env.CGO_ENABLED = 0;

  vendorHash = "sha256-IjCBf1h6r+EDLfgGqP/VfsHaD5oPkIR33nYBAcb6SLY=";

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=v${version}"
  ];

  meta = with lib; {
    description = "A tool for managing secrets by storing them in AWS SSM Parameter Store";
    homepage = "https://github.com/segmentio/chamber";
    license = licenses.mit;
    maintainers = with maintainers; [ kalekseev ];
    mainProgram = "chamber";
  };
}
