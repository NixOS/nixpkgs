{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "redfish-exporter";
  version = "0.11.0";
  src = fetchFromGitHub {
    owner = "jenningsloy318";
    repo = "redfish_exporter";
    rev = "d388474c4024d09df0f3ab0290068e9072a7cf21";
    hash = "sha256-TkbME8rdmDvxzpK3KKk4XKS35oVGWaDVBzqiAjx+6sA==";
  };
  vendorHash = "sha256-M/5n6LFX8T0BCbM/TdA1qJN/3lNXLi/ZVlWucenp0yk=";
  ldflags = [
    "-X 'main.Version=${version}'"
    "-X 'main.BuildRevision=${src.rev}'"
    "-X 'main.BuildBranch=master'"
    "-X 'main.BuildUser=nix@nixpkgs'"
    "-X 'main.BuildDate=unknown'"
  ];

  # Todo?
  #   passthru.tests = { inherit (nixosTests.prometheus-exporters) redfish; };
  # https://github.com/NixOS/nixpkgs/blob/master/nixos/tests/prometheus-exporters.nix

  meta = {
    description = "Prometheus exporter for Redfish metrics";
    mainProgram = "redfish_exporter";
    homepage = "https://github.com/jenningsloy318/redfish_exporter";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ underknowledge ];
    platforms = lib.platforms.linux;
  };
}
