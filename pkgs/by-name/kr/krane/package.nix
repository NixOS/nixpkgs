{
  lib,
  bundlerApp,
  bundlerUpdateScript,
}:

bundlerApp {
  pname = "krane";
  gemdir = ./.;
  exes = [ "krane" ];

  passthru.updateScript = bundlerUpdateScript "krane";

  meta = {
    description = "Command-line tool that helps you ship changes to a Kubernetes namespace and understand the result";
    homepage = "https://github.com/Shopify/krane";
    changelog = "https://github.com/Shopify/krane/blob/main/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kira-bruneau ];
  };
}
