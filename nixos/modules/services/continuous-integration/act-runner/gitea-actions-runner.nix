{
  imports = [
    (import ./generic.nix {
      attributeName = "gitea-actions-runner";
      docsUrl = "https://docs.gitea.com/usage/actions";
      labelsUrl = "https://docs.gitea.com/usage/actions/act-runner#labels";
      mainProgram = "act_runner";
      name = "gitea";
      prettyName = "Gitea";
      runnerPrettyName = "Gitea Actions Runner";
      srcUrl = "https://gitea.com/gitea/act_runner";
    })
  ];
}
