{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

let
  version = "15.0.2";
  pname = "cabal-cli";
in
buildNpmPackage {
  inherit version pname;

  src = fetchFromGitHub {
    owner = "cabal-club";
    repo = "cabal-cli";
    rev = "v${version}";
    hash = "sha256-DZ+F+pgPc8WuiBhLgxNO5es5lA996fJdvZyg6QjfrHg=";
  };

  npmDepsHash = "sha256-Oqyx6pytDrYg1JbHawKxnnWEJxaFUaM9LcREizh3LFQ=";

  dontNpmBuild = true;

  env.NODE_OPTIONS = "--openssl-legacy-provider";

  meta = {
    description = "Terminal client for Cabal, the p2p chat platform";
    homepage = "https://cabal.chat";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ kototama ];
  };
}
