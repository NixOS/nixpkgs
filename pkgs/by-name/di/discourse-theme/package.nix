{
  lib,
  bundlerApp,
  bundlerUpdateScript,
}:

bundlerApp {
  pname = "discourse_theme";

  gemdir = ./.;
  exes = [ "discourse_theme" ];

  passthru.updateScript = bundlerUpdateScript "discourse_theme";

  meta = {
    description = "CLI helper for creating and maintaining Discourse themes and theme components";
    homepage = "https://meta.discourse.org/t/install-the-discourse-theme-cli-console-app-to-help-you-build-themes/82950";
    license = lib.licenses.mit;
    mainProgram = "discourse_theme";
    maintainers = with lib.maintainers; [ das-g ];
    platforms = lib.platforms.unix;
  };
}
