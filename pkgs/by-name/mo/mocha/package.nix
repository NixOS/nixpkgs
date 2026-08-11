{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "mocha";
  version = "11.8.0";

  src = fetchFromGitHub {
    owner = "mochajs";
    repo = "mocha";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zfKUfB5clRrjorj9IgxbpWc721GC3Wa464+n8iATAJ4=";
  };

  npmDepsHash = "sha256-iUXr89ZxR4QkOn200lavkm8xfeZpqe+Gymw+I5O28do=";

  postInstall = ''
    # Installed only for backwards compat, but should just be removed.
    rm $out/bin/_mocha
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/mochajs/mocha/blob/v${finalAttrs.version}/CHANGELOG.md";
    description = "Simple, flexible, fun Javascript test framework for Node.js & the browser";
    homepage = "https://mochajs.org";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "mocha";
  };
})
