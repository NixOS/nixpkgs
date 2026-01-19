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
  version = "1.9.1";
  pname = "scrutiny-collector";

  src = fetchFromGitHub {
    owner = "Starosdev";
    repo = "scrutiny";
    tag = "v${finalAttrs.version}";
    hash = "sha256-t0oy1y8aJadgmQE/pR/8kwW4GAuKvsUtU76aV1nhww0=";
  };

  subPackages = "collector/cmd/collector-metrics";

  vendorHash = "sha256-nfL+44lKBmAcScoV0AHotSotQz4Z3kHIpePERuncM6c=";

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
    homepage = "https://github.com/Starosdev/scrutiny";
    changelog = "https://github.com/Starosdev/scrutiny/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ samasaur ];
    mainProgram = "scrutiny-collector-metrics";
    platforms = lib.platforms.linux;
  };
})
