{
  buildGoModule,
  fetchFromGitHub,
  makeWrapper,
  smartmontools,
  nixosTests,
  lib,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  version = "0.9.1";
  pname = "scrutiny-collector";

  src = fetchFromGitHub {
    owner = "AnalogJ";
    repo = "scrutiny";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xEMHkISPBHinT6vRyrWPudvmTiX5gYxMkCEoSm2gLWA=";
  };

  subPackages = "collector/cmd/collector-metrics";

  vendorHash = "sha256-Em8k2AFoZv4TD4HFkkNIdyPj7IBOFiUIKffkifWfZFY=";

  nativeBuildInputs = [ makeWrapper ];

  env.CGO_ENABLED = 0;

  ldflags = [ "-extldflags=-static" ];

  tags = [ "static" ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp $GOPATH/bin/collector-metrics $out/bin/scrutiny-collector-metrics
    wrapProgram $out/bin/scrutiny-collector-metrics \
      --prefix PATH : ${lib.makeBinPath [ smartmontools ]}
    runHook postInstall
  '';

  passthru.tests.scrutiny-collector = nixosTests.scrutiny;
  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Hard disk metrics collector for Scrutiny";
    homepage = "https://github.com/AnalogJ/scrutiny";
    changelog = "https://github.com/AnalogJ/scrutiny/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      samasaur
      svistoi
    ];
    mainProgram = "scrutiny-collector-metrics";
  };
})
