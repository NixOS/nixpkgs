{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage rec {
  pname = "all-the-package-names";
  version = "2.0.2228";

  src = fetchFromGitHub {
    owner = "nice-registry";
    repo = "all-the-package-names";
    tag = "v${version}";
    hash = "sha256-Qq5dHI6Z33MbGvOKSzONeYgb/u0kgH3PFPV9zhfjkyY=";
  };

  npmDepsHash = "sha256-NxyOqp3chgionveBfCVN5VnMF7cLZhmV15Ff5n91lQQ=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "List of all the public package names on npm";
    homepage = "https://github.com/nice-registry/all-the-package-names";
    license = lib.licenses.mit;
    mainProgram = "all-the-package-names";
    maintainers = with lib.maintainers; [ donovanglover ];
  };
}
