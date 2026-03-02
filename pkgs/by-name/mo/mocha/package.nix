{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "mocha";
  version = "11.7.5";

  src = fetchFromGitHub {
    owner = "mochajs";
    repo = "mocha";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Bk/yF3z/DZ4h9mj1a/EG5ofC6/CIpLd81iQ1w7XkZ0A=";
  };

  npmDepsHash = "sha256-dcq6P4BB6w7GGMzW2GfF8AzDnqPV/BS5nz+dxVjnc3o=";

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
    maintainers = with lib.maintainers; [ pyrox0 ];
    mainProgram = "mocha";
  };
})
