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

  meta = with lib; {
    description = "Deploy web apps anywhere";
    homepage = "https://kamal-deploy.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ nathanruiz ];
    mainProgram = "kamal";
  };
}
