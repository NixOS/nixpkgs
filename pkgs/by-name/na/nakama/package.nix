{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "nakama";
  version = "3.36.0";

  src = fetchFromGitHub {
    owner = "heroiclabs";
    repo = "nakama";
    tag = "v${finalAttrs.version}";
    hash = "sha256-QPp9VnPh4pP9k7Ee7ydl67wpA13lIVSjkTT3r2qqp14=";
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
    "-X main.version=${finalAttrs.version}"
  ];

  doCheck = false;

  meta = {
    description = "Distributed server for social and realtime games and apps";
    homepage = "https://heroiclabs.com/nakama/";
    changelog = "https://github.com/heroiclabs/nakama/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.qxrein ];
    mainProgram = "nakama";
  };
})
