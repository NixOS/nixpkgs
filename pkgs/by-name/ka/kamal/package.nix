{
  lib,
  ruby,
  bundlerApp,
  bundlerUpdateScript,
}:

bundlerApp {
  pname = "kamal";
  gemdir = ./.;
  inherit ruby;

  exes = [ "kamal" ];

  meta = {
    description = "Kamal: Deploy web apps anywhere";
    homepage = "https://kamal-deploy.org/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nathanruiz ];
    mainProgram = "kamal";
  };
}
