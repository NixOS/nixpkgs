{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "nakama";
  version = "3.34.1";

  src = fetchFromGitHub {
    owner = "heroiclabs";
    repo = "nakama";
    tag = "v${version}";
    hash = "sha256-fCQM3e1lsy1xHxoUZnVxMsRh+RLvNGGCN86DsEMjQys=";
  };

  vendorHash = null;

  subPackages = [ "." ];

  postPatch = ''
    substituteInPlace main.go \
      --replace-fail  'os.Getenv("NAKAMA_TELEMETRY") != "0"' \
                      'os.Getenv("NAKAMA_TELEMETRY") == "1"'
  '';

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  doCheck = false;

  meta = {
    description = "Distributed server for social and realtime games and apps";
    homepage = "https://heroiclabs.com/nakama/";
    changelog = "https://github.com/heroiclabs/nakama/releases/tag/v${version}";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.qxrein ];
    mainProgram = "nakama";
  };
}
