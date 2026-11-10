{
  lib,
  ruby,
  bundlerApp,
  bundlerUpdateScript,
}:

bundlerApp {
  pname = "serverspec";
  gemdir = ./.;

  inherit ruby;

  exes = [ "serverspec-init" ];

  passthru.updateScript = bundlerUpdateScript "serverspec";

  meta = {
    description = "RSpec tests for your servers configured by CFEngine, Puppet, Ansible, Itamae or anything else";
    homepage = "https://serverspec.org/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dylanmtaylor ];
    mainProgram = "serverspec-init";
  };
}
