{ lib, bundlerApp }:

bundlerApp {
  pname = "danger-gitlab";
  gemdir = ./.;
  exes = [ "danger" ];

  meta = {
    description = "Gem that exists to ensure all dependencies are set up for Danger with GitLab";
    homepage = "https://github.com/danger/danger-gitlab-gem";
    license = lib.licenses.mit;
    maintainers = lib.teams.serokell.members;
    mainProgram = "danger";
  };
}
