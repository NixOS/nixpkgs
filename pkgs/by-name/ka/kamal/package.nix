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

<<<<<<< HEAD
  meta = {
    description = "Deploy web apps anywhere";
    homepage = "https://kamal-deploy.org/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nathanruiz ];
=======
  meta = with lib; {
    description = "Deploy web apps anywhere";
    homepage = "https://kamal-deploy.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ nathanruiz ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "kamal";
  };
}
