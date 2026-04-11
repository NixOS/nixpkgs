{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  nixosTests,
  testers,
  grafana-loki,
}:

buildGoModule (finalAttrs: {
  version = "3.7.1";
  pname = "grafana-loki";

  src = fetchFromGitHub {
    owner = "grafana";
    repo = "loki";
    rev = "v${finalAttrs.version}";
    hash = "sha256-SSsTwqk6Cebk5dtSdPQzn3jrwMluoQgsd8JsV2WhaTY=";
  };

  vendorHash = null;

  subPackages = [
    # TODO split every executable into its own package
    "cmd/loki"
    "cmd/loki-canary"
    "cmd/logcli"
    "cmd/lokitool"
  ];

  passthru = {
    tests = {
      inherit (nixosTests) loki;
      version = testers.testVersion {
        command = "loki --version";
        package = grafana-loki;
      };
    };

    updateScript = nix-update-script { };
  };

  ldflags =
    let
      t = "github.com/grafana/loki/v3/pkg/util/build";
    in
    [
      "-s"
      "-w"
      "-X ${t}.Version=${finalAttrs.version}"
      "-X ${t}.BuildUser=nix@nixpkgs"
      "-X ${t}.BuildDate=unknown"
      "-X ${t}.Branch=unknown"
      "-X ${t}.Revision=unknown"
    ];

  meta = {
    description = "Like Prometheus, but for logs";
    mainProgram = "loki";
    license = with lib.licenses; [
      agpl3Only
      asl20
    ];
    homepage = "https://grafana.com/oss/loki/";
    changelog = "https://github.com/grafana/loki/releases/tag/v${finalAttrs.version}";
    maintainers = with lib.maintainers; [
      globin
      mmahut
      emilylange
      ryan4yin
    ];
  };
})
