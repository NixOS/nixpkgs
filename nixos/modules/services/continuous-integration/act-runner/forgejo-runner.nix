{
  imports = [
    (import ./generic.nix {
      attributeName = "forgejo-runner";
      name = "forgejo";
      prettyName = "Forgejo";
      runnerPrettyName = "Forgejo Runner";
      srcUrl = "https://code.forgejo.org/forgejo/runner";
      docsUrl = "https://forgejo.org/docs/latest/user/actions/overview";
      labelsUrl = "https://forgejo.org/docs/latest/admin/actions";
      mainProgram = "forgejo-runner";
    })
  ];
}
