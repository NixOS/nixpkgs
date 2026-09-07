{
  lib,
  bundlerApp,
  bundlerUpdateScript,
}:

bundlerApp {
  pname = "github_changelog_generator";
  gemdir = ./.;
  exes = [ "github_changelog_generator" ];

  passthru.updateScript = bundlerUpdateScript "github-changelog-generator";

  meta = {
    description = "Fully automated changelog generation - This gem generates a changelog file based on tags, issues and merged pull requests";
    homepage = "https://github.com/github-changelog-generator/github-changelog-generator";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      Scriptkiddi
      nicknovitski
    ];
    platforms = lib.platforms.unix;
  };
}
