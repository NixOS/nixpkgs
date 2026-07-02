{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "mocha";
  version = "11.7.7";

  src = fetchFromGitHub {
    owner = "mochajs";
    repo = "mocha";
    tag = "v${finalAttrs.version}";
    hash = "sha256-U05dHIIk9MwMY2mV9WZZl2ibS0e35tkJg/EV3EHa6C4=";
  };

  npmDepsHash = "sha256-crMuMnLJXVSzDMiZDtWXVW0x4XtZ4QXkK7qL90/kkHA=";

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
