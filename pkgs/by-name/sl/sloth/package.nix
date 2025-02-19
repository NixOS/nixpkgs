{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule rec {
  pname = "sloth";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "slok";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-KMVD7uH3Yg9ThnwKKzo6jom0ctFywt2vu7kNdfjiMCs=";
  };

  vendorHash = "sha256-j6qXUQ/Tu3VNQL5xBOHloRn5DH3KG/znCLi1s8RIoL8=";

  subPackages = [ "cmd/sloth" ];

  meta = {
    description = "Easy and simple Prometheus SLO (service level objectives) generator";
    homepage = "https://sloth.dev/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nrhtr ];
    platforms = lib.platforms.unix;
    mainProgram = "sloth";
  };
}
