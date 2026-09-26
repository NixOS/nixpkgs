{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:
buildGoModule rec {
  pname = "gs1200-exporter";
  version = "2.11.13";
  __structuredAttrs = true;
  src = fetchFromGitHub {
    owner = "robinelfrink";
    repo = "gs1200-exporter";
    tag = "v${version}";
    hash = "sha256-s+CdJBa9k4DBYBiwEAtWJz1r6DvDQtZR+dEB3FBSu3g=";
  };
  vendorHash = "sha256-R8is2TM2npCY1eOTRsL1spTJWf/KiBqHpjr4EjraLeU=";
  postPatch = ''
    substituteInPlace go.mod --replace-fail "go 1.26.4" "go 1.26.3"
  '';
  passthru.tests = {
    inherit (nixosTests) gs1200-exporter;
  };
  meta = {
    description = "Prometheus exporter for Zyxel GS1200 switches";
    homepage = "https://github.com/robinelfrink/gs1200-exporter";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ DerGrumpf ];
    mainProgram = "gs1200-exporter";
  };
}
