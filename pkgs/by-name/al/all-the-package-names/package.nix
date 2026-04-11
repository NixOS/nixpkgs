{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage rec {
  pname = "all-the-package-names";
  version = "2.0.2413";

  src = fetchFromGitHub {
    owner = "nice-registry";
    repo = "all-the-package-names";
    tag = "v${version}";
    hash = "sha256-loI9wKz0EcePvM2kXqmxNx9rfC/VaMCmJtm0dTjWoOk=";
  };

  npmDepsHash = "sha256-6XLDdamRG+IVq/zdyKKlIsnfUVD8pKES7K7hm+yTQ78=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "List of all the public package names on npm";
    homepage = "https://github.com/nice-registry/all-the-package-names";
    license = lib.licenses.mit;
    mainProgram = "all-the-package-names";
    maintainers = with lib.maintainers; [ donovanglover ];
  };
}
