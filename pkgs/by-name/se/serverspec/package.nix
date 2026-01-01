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

<<<<<<< HEAD
  meta = {
    description = "RSpec tests for your servers configured by CFEngine, Puppet, Ansible, Itamae or anything else";
    homepage = "https://serverspec.org/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dylanmtaylor ];
=======
  meta = with lib; {
    description = "RSpec tests for your servers configured by CFEngine, Puppet, Ansible, Itamae or anything else";
    homepage = "https://serverspec.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ dylanmtaylor ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "serverspec-init";
  };
}
