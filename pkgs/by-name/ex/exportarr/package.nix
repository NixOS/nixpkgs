{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "exportarr";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "onedr0p";
    repo = "exportarr";
    rev = "v${version}";
    hash = "sha256-q1G0auXwmuJI0jecXcNg7PMF/+vZPGT00gLt/Qa86dE=";
  };

  vendorHash = "sha256-XKIfOKgzJ41gQl/Jd8ZO3oNimZcoIY2d38ZojZAf53c=";

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
