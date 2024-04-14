{ lib, bundlerApp }:

bundlerApp {
  pname = "danger-gitlab";
  gemdir = ./.;
  exes = [ "danger" ];

  meta = with lib; {
    description = "A gem that exists to ensure all dependencies are set up for Danger with GitLab";
    homepage = "https://github.com/danger/danger-gitlab-gem";
    license = licenses.mit;
    maintainers = teams.serokell.members;
    mainProgram = "danger";
  };
}
