{
  bundlerApp,
  bundlerUpdateScript,
  lib,
  openvox,
  testers,
}:

bundlerApp {
  pname = "openvox";
  gemdir = ./.;
  exes = [ "puppet" ];

  passthru = {
    tests.version = testers.testVersion {
      package = openvox;
      command = "HOME=$(mktemp -d) puppet --version";
      inherit ((import ./gemset.nix).openvox) version;
    };
    updateScript = bundlerUpdateScript "openvox";
  };

  meta = {
    description = "Server automation framework and application";
    homepage = "https://github.com/OpenVoxProject/openvox";
    changelog = "https://github.com/OpenVoxProject/openvox/blob/main/CHANGELOG.md";
    license = lib.licenses.asl20;
    mainProgram = "puppet";
    maintainers = with lib.maintainers; [ skyethepinkcat ];
  };
}
