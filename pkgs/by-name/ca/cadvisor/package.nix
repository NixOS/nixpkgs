{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule rec {
  pname = "cadvisor";
  version = "0.55.1";

  src = fetchFromGitHub {
    owner = "google";
    repo = "cadvisor";
    rev = "v${version}";
    hash = "sha256-m3FwFVQeLXQrWEpHjeWnoAxKTNMGkEBxSXJ3vtwv2hs=";
  };

  modRoot = "./cmd";

  vendorHash = "sha256-zuniV34lRxCS2MSlxja7hNeUjva4rjhc8LK12AW68Mg=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/google/cadvisor/version.Version=${version}"
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
    maintainers = with lib.maintainers; [ offline ];
    platforms = lib.platforms.linux;
  };
}
