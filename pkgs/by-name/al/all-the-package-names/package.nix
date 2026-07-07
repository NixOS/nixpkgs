{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage rec {
  pname = "all-the-package-names";
  version = "2.0.2495";

  src = fetchFromGitHub {
    owner = "nice-registry";
    repo = "all-the-package-names";
    tag = "v${version}";
    hash = "sha256-65UbcJXOUZVDEtjDy0PkRLPIlhk8/WxItDeyiULLpNY=";
  };

  npmDepsHash = "sha256-Vv3rJBDRSwWnbYFO01M0rLJM3b2gP0z8wAi9T2nRwxQ=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "List of all the public package names on npm";
    homepage = "https://github.com/nice-registry/all-the-package-names";
    license = lib.licenses.mit;
    mainProgram = "all-the-package-names";
    maintainers = with lib.maintainers; [ donovanglover ];
  };
}
