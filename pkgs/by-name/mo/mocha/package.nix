{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage (finalAttrs: {
  pname = "mocha";
  version = "11.7.4";

  src = fetchFromGitHub {
    owner = "mochajs";
    repo = "mocha";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mRXdAPKDNnQzr8oz6NrTeUFgT7aBbsTl4TxFvjcVqCs=";
  };

  npmDepsHash = "sha256-NTJ27KucQcrnpPVtEX3zr6qQZjaLzNHPhgJefntE8hg=";

  postInstall = ''
    # Installed only for backwards compat, but should just be removed.
    rm $out/bin/_mocha
  '';

  meta = {
    changelog = "https://github.com/mochajs/mocha/blob/v${finalAttrs.version}/CHANGELOG.md";
    description = "Simple, flexible, fun Javascript test framework for Node.js & the browser";
    homepage = "https://mochajs.org";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pyrox0 ];
    mainProgram = "mocha";
  };
})
