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

  meta = with lib; {
    description = "RSpec tests for your servers configured by CFEngine, Puppet, Ansible, Itamae or anything else";
    homepage = "https://serverspec.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ dylanmtaylor ];
    mainProgram = "serverspec-init";
  };
}
