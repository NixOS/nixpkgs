{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "mocha";
  version = "11.7.6";

  src = fetchFromGitHub {
    owner = "mochajs";
    repo = "mocha";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pY6LYMitbhOfjNf00UuUbLgdZii7Nr/8/SlBgM5pYMI=";
  };

  npmDepsHash = "sha256-1uisNcDlv/EY+Mq24rM7BgA8GREKKvxX/gHt8dHlX2Q=";

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
