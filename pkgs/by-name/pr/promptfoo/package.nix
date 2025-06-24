{
  buildNpmPackage,
  fetchFromGitHub,
  lib,
}:

buildNpmPackage rec {
  pname = "promptfoo";
  version = "0.115.1";

  src = fetchFromGitHub {
    owner = "promptfoo";
    repo = "promptfoo";
    rev = "${version}";
    hash = "sha256-KGi5IV4R0WOvshTrVaVN3u0pO8as/A4/858JlFOdc0c=";
  };

  npmDepsHash = "sha256-vkZx2c5vvjHM8kSLukL7YQwRLnwSdFLa+xKhn+ekuts=";

  dontNpmBuild = true;

  meta = with lib; {
    description = "Test your prompts, models, RAGs. Evaluate and compare LLM outputs, catch regressions, and improve prompt quality";
    mainProgram = "promptfoo";
    homepage = "https://www.promptfoo.dev/";
    changelog = "https://github.com/promptfoo/promptfoo/releases/tag/${version}";
    license = licenses.mit;
    maintainers = [ maintainers.nathanielbrough ];
  };

   # Prevent Playwright download as that will cause the package build to fail
  PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD = "1";

  # Remove broken symlinks after installation
  postInstall = ''
    rm -f $out/lib/node_modules/promptfoo/node_modules/app
    rm -f $out/lib/node_modules/promptfoo/node_modules/promptfoo-docs
  '';
}
