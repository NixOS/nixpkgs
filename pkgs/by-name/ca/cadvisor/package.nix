{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule (finalAttrs: {
  pname = "cadvisor";
  version = "0.60.6";

  src = fetchFromGitHub {
    owner = "google";
    repo = "cadvisor";
    rev = "v${finalAttrs.version}";
    hash = "sha256-WVa0KeMSeZ4syAIQv2Xz0mhEBiPZEpPGdUiKwx+873E=";
  };

  modRoot = "./cmd";

  vendorHash = "sha256-P4hBs5kUovCdlbo8oGlG2pNLcUNhrdD/ig/RkH71llw=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/google/cadvisor/version.Version=${finalAttrs.version}"
  ];

  postInstall = ''
    mv $out/bin/{cmd,cadvisor}
    rm $out/bin/example
  '';

  passthru.tests = { inherit (nixosTests) cadvisor; };

  meta = {
    description = "Analyzes resource usage and performance characteristics of running docker containers";
    mainProgram = "cadvisor";
    homepage = "https://github.com/google/cadvisor";
    license = lib.licenses.asl20;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
