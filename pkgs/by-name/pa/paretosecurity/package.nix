{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  paretosecurity,
  nixosTests,
}:

buildGoModule rec {
  pname = "paretosecurity";
  version = "0.0.88";

  src = fetchFromGitHub {
    owner = "ParetoSecurity";
    repo = "agent";
    rev = version;
    hash = "sha256-UVnZhkajrc9q6AZvIU7oi931ugxkiVSPk1NugAERnek=";
  };

  vendorHash = "sha256-HReQu23sHLaxc5N8h2vYv64ruJPmY4HM9whAEKV+3Eo=";
  proxyVendor = true;

  subPackages = [
    "cmd/paretosecurity"
  ];

  ldflags = [
    "-s"
    "-X=github.com/ParetoSecurity/agent/shared.Version=${version}"
    "-X=github.com/ParetoSecurity/agent/shared.Commit=${src.rev}"
    "-X=github.com/ParetoSecurity/agent/shared.Date=1970-01-01T00:00:00Z"
  ];

  passthru.tests = {
    version = testers.testVersion {
      version = "${version}";
      package = paretosecurity;
    };
    integration_test = nixosTests.paretosecurity;
  };

  meta = {
    description = "Pareto Security agent makes sure your laptop is correctly configured for security.";
    longDescription = ''
      The Pareto Security agent is a free and open source app to help you make
      sure that your laptop is configured for security.

      By default, it's a CLI command that prints out a report on basic security
      settings such as if you have disk encryption and firewall enabled.

      If you use the `services.paretosecurity` NixOS module, you also get a
      root helper, so that you can run the checker in userspace. Some checks
      require root permissions, and the checker asks the helper to run those.

      Additionally, you can run `paretosecurity link` to configure the agent
      to send the status of checks to https://dash.paretosecurity.com to make
      compliance people happy. No sending happens until your device is linked.
    '';
    homepage = "https://github.com/ParetoSecurity/agent";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ zupo ];
    mainProgram = "paretosecurity";
  };
}
