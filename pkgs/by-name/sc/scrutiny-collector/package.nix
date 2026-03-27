{
  buildGoModule,
  fetchFromGitHub,
  makeWrapper,
  smartmontools,
  nixosTests,
  lib,
  nix-update-script,
}:
let
  version = "0.8.6";
in
buildGoModule rec {
  inherit version;
  pname = "scrutiny-collector";

  src = fetchFromGitHub {
    owner = "AnalogJ";
    repo = "scrutiny";
    tag = "v${version}";
    hash = "sha256-0NgAdgtlsAetXfFqJdYpvzEXL4Ibh4yzAjOaOFoMvrs=";
  };

  subPackages = "collector/cmd/collector-metrics";

  vendorHash = "sha256-4qjKGjCvB0ggf6Cda7LfMeqbbBbhGcxB2ZfymUhajq8=";

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
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      samasaur
      svistoi
    ];
    mainProgram = "scrutiny-collector-metrics";
  };
}
