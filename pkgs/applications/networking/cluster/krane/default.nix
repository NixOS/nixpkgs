{ lib
, bundlerApp
, bundlerUpdateScript
}:

bundlerApp {
  pname = "krane";
  gemdir = ./.;
  exes = [ "krane" ];

  passthru.updateScript = bundlerUpdateScript "krane";

  meta = with lib; {
    description = "Command-line tool that helps you ship changes to a Kubernetes namespace and understand the result";
    homepage = "https://github.com/Shopify/krane";
    changelog = "https://github.com/Shopify/krane/blob/main/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ kira-bruneau ];
  };
}
