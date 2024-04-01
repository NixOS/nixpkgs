{ buildGoModule
, fetchFromGitHub
, makeWrapper
, smartmontools
, nixosTests
, lib
, nix-update-script
}:
let
  version = "0.8.0";
in
buildGoModule rec {
  inherit version;
  pname = "scrutiny-collector";

  src = fetchFromGitHub {
    owner = "AnalogJ";
    repo = "scrutiny";
    rev = "refs/tags/v${version}";
    hash = "sha256-ysjE2nn1WwhEiFIvJ5cRCJQf9mECTgiGUyenwf3mKTA=";
  };

  subPackages = "collector/cmd/collector-metrics";

  vendorHash = "sha256-SiQw6pq0Fyy8Ia39S/Vgp9Mlfog2drtVn43g+GXiQuI=";

  buildInputs = [ makeWrapper ];

  CGO_ENABLED = 0;

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
    description = "Hard disk metrics collector for Scrutiny.";
    homepage = "https://github.com/AnalogJ/scrutiny";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jnsgruk ];
    mainProgram = "scrutiny-collector-metrics";
    platforms = lib.platforms.linux;
  };
}
