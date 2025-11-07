{
  stdenv,
  lib,
  buildGoModule,
  fetchFromGitHub,
  makeWrapper,
  nix-update-script,
  nixosTests,
  systemd,
  testers,
  grafana-loki,
}:

buildGoModule rec {
  version = "3.6.2";
  pname = "grafana-loki";

  src = fetchFromGitHub {
    owner = "grafana";
    repo = "loki";
    rev = "v${version}";
    hash = "sha256-7Z1TzAtKBrivnpkgipWK33Yyc6yguoNuinqSvG5gvXM=";
  };

  vendorHash = null;

  subPackages = [
    # TODO split every executable into its own package
    "cmd/loki"
    "cmd/loki-canary"
    "clients/cmd/promtail"
    "cmd/logcli"
    "cmd/lokitool"
  ];

  tags = [ "promtail_journal_enabled" ];

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ systemd.dev ];

  preFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    wrapProgram $out/bin/promtail \
      --prefix LD_LIBRARY_PATH : "${lib.getLib systemd}/lib"
  '';

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
      "-X ${t}.Version=${version}"
      "-X ${t}.BuildUser=nix@nixpkgs"
      "-X ${t}.BuildDate=unknown"
      "-X ${t}.Branch=unknown"
      "-X ${t}.Revision=unknown"
    ];

  meta = {
    description = "Like Prometheus, but for logs";
    mainProgram = "promtail";
    license = with lib.licenses; [
      agpl3Only
      asl20
    ];
    homepage = "https://grafana.com/oss/loki/";
    changelog = "https://github.com/grafana/loki/releases/tag/v${version}";
    maintainers = with lib.maintainers; [
      globin
      mmahut
      emilylange
      ryan4yin
    ];
  };
}
