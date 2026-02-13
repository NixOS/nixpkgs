{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "playwright-cli";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "playwright-cli";
    tag = "v${version}";
    hash = "sha256-9LuLQ2klYz91rEkxNDwcx0lYgE6GPoTJkwgxI/4EHgg=";
  };

  npmDepsHash = "sha256-DvorQ40CCNQJNQdTPFyMBErFNicSWkNT/e6S8cfZlRA=";

  dontNpmBuild = true;

  passthru = {
    # Newer upstream tags intentionally print a deprecation message and exit.
    skipBulkUpdate = true;
  };

  meta = {
    description = "Playwright CLI for browser automation";
    homepage = "https://github.com/microsoft/playwright-cli";
    changelog = "https://github.com/microsoft/playwright-cli/releases/tag/v${version}";
    license = lib.licenses.asl20;
    mainProgram = "playwright-cli";
  };
}
