{
  lib,
  ruby,
  bundlerApp,
}:

bundlerApp {
  pname = "kamal";
  gemdir = ./.;
  inherit ruby;

  exes = [ "kamal" ];

  meta = {
    description = "Deploy web apps anywhere";
    homepage = "https://kamal-deploy.org/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nathanruiz ];
    mainProgram = "kamal";
  };
}
