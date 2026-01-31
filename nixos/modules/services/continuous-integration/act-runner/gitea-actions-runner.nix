{
  imports = [
    (import ./generic.nix {
      attributeName = "gitea-actions-runner";
      mainProgram = "act_runner";
      name = "gitea";
      prettyName = "Gitea";
      runnerPrettyName = "Gitea Actions Runner";
      srcUrl = "https://gitea.com/gitea/act_runner";
    })
  ];
}
