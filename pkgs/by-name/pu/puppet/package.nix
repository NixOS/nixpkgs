{
  bundlerApp,
  bundlerUpdateScript,
  lib,
  puppet,
  testers,
}:

bundlerApp {
  pname = "puppet";
  gemdir = ./.;
  exes = [ "puppet" ];

  passthru = {
    tests.version = testers.testVersion {
      package = puppet;
      command = "HOME=$(mktemp -d) puppet --version";
      inherit ((import ./gemset.nix).puppet) version;
    };
    updateScript = bundlerUpdateScript "puppet";
  };

  meta = {
    description = "Server automation framework and application";
    homepage = "https://github.com/puppetlabs/puppet";
    changelog = "https://github.com/puppetlabs/puppet/blob/main/CHANGELOG.md";
    license = lib.licenses.asl20;
    mainProgram = "puppet";
    maintainers = with lib.maintainers; [ baloo ];
  };
}
