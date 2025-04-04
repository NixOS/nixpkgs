{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "exportarr";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "onedr0p";
    repo = "exportarr";
    rev = "v${version}";
    hash = "sha256-iNcdD2zigBZ2phtCkHRV0GZPrEjopV0K+vin1Zkb3Oo=";
  };

  vendorHash = "sha256-F5WOSsjeOzMaj4Yze11OnqpgL1l87wpgl3OQEGya//M=";

  subPackages = [ "cmd/exportarr" ];

  CGO_ENABLE = 0;

  ldflags = [
    "-s"
    "-w"
  ];

  tags = lib.optionals stdenv.hostPlatform.isLinux [ "netgo" ];

  preCheck = ''
    # Run all tests.
    unset subPackages
  '';

  meta = with lib; {
    description = "AIO Prometheus Exporter for Sonarr, Radarr or Lidarr";
    mainProgram = "exportarr";
    homepage = "https://github.com/onedr0p/exportarr";
    changelog = "https://github.com/onedr0p/exportarr/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ azahi ];
  };
}
