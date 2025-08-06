{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule rec {
  pname = "c2FmZQ";
  version = "0.4.31";

  src = fetchFromGitHub {
    owner = "c2FmZQ";
    repo = "c2FmZQ";
    rev = "v${version}";
    hash = "sha256-NoC7LiH5fxXklJlni4PvCz69ZBwJTiIGvg0B7bq8s3c=";
  };

  ldflags = [
    "-s"
    "-w"
  ];

  sourceRoot = "${src.name}/c2FmZQ";

  vendorHash = "sha256-E4SdX8DIyocnYpfy+VoGdY1sKUhy5LV0xIuR9EFsyYc=";

  subPackages = [
    "c2FmZQ-client"
    "c2FmZQ-server"
  ];

  passthru.tests = { inherit (nixosTests) c2fmzq; };

  meta = with lib; {
    description = "Securely encrypt, store, and share files, including but not limited to pictures and videos";
    homepage = "https://github.com/c2FmZQ/c2FmZQ";
    license = licenses.gpl3Only;
    mainProgram = "c2FmZQ-server";
    maintainers = with maintainers; [ hmenke ];
    platforms = platforms.linux;
  };
}
