{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage rec {
  pname = "all-the-package-names";
  version = "2.0.2296";

  src = fetchFromGitHub {
    owner = "nice-registry";
    repo = "all-the-package-names";
    tag = "v${version}";
    hash = "sha256-cAB0YF1Qi98yVZgU8Bi/zVB08TebOeQpdxHlVgR9qbg=";
  };

  npmDepsHash = "sha256-oaaNWLaUV7Hd1x6QEw4p3n7MZQJeXeUqWH2nMNGm+H4=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "List of all the public package names on npm";
    homepage = "https://github.com/nice-registry/all-the-package-names";
    license = lib.licenses.mit;
    mainProgram = "all-the-package-names";
    maintainers = with lib.maintainers; [ donovanglover ];
  };
}
