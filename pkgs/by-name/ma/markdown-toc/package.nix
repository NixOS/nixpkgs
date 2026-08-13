{
  buildNpmPackage,
  fetchFromGitHub,
  lib,
}:

buildNpmPackage (finalAttrs: {
  pname = "markdown-toc";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "jonschlinkert";
    repo = "markdown-toc";
    tag = finalAttrs.version;
    hash = "sha256-CgyAxXcLrdk609qoXjyUgpA+NIlWrkBsE7lf5YnPagQ=";
  };

  # This package has no build script so the `devDependencies` are unnecessary.
  patches = [ ./no-dev-deps.patch ];
  # Because we reduced the size of `package-lock.json` by omitting
  # `devDependencies`, it no longer contains any package versions that were
  # published after 2023, meaning it would likely not change if it were
  # regenerated again in the future.
  postPatch = ''
    cp ${./package-lock.json} ./package-lock.json
  '';
  npmDepsHash = "sha256-2WDlZ4OD/R+3ya0AE9rPRHXbCTVbmiyXtaRrgCS/jGo=";

  dontNpmBuild = true;

  meta = {
    description = "API and CLI for generating a markdown TOC (table of contents)";
    homepage = "https://github.com/jonschlinkert/markdown-toc";
    license = lib.licenses.mit;
    mainProgram = "markdown-toc";
    maintainers = with lib.maintainers; [ samestep ];
  };
})
