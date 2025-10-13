{
  lib,
  bundlerApp,
  bundlerUpdateScript,
}:

bundlerApp {
  pname = "danger-gitlab";
  gemdir = ./.;
  exes = [ "danger" ];

  passthru.updateScript = bundlerUpdateScript "danger-gitlab";

  meta = {
    description = "Gem that exists to ensure all dependencies are set up for Danger with GitLab";
    homepage = "https://github.com/danger/danger-gitlab-gem";
    license = lib.licenses.mit;
    teams = with lib.teams; [ serokell ];
    mainProgram = "danger";
  };
}
