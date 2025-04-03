{
  lib,
  buildNpmPackage,
  fetchzip,
}:

buildNpmPackage rec {
  pname = "claude-code";
  version = "0.2.59";

  src = fetchzip {
    url = "https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-${version}.tgz";
    hash = "sha256-XHHWmDw9qBM4fQ975wSk12hJnr4+1H4AhlNc+IBV3qs=";
  };

  npmDepsHash = "sha256-KorQlEB90EDE+NIxyUh1apqCDzgrCpwcaOy2mt2mz1s=";

  postPatch = ''
    cp ${./package-lock.json} package-lock.json
  '';

  dontNpmBuild = true;

  AUTHORIZED = "1";

  # `claude-code` tries to auto-update by default, this disables that functionality.
  # Note that the `DISABLE_AUTOUPDATER` environment variable is not documented, so this trick may
  # not continue to work.
  postInstall = ''
    wrapProgram $out/bin/claude \
      --set DISABLE_AUTOUPDATER 1
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "An agentic coding tool that lives in your terminal, understands your codebase, and helps you code faster";
    homepage = "https://github.com/anthropics/claude-code";
    downloadPage = "https://www.npmjs.com/package/@anthropic-ai/claude-code";
    license = lib.licenses.unfree;
    maintainers = [ lib.maintainers.malo ];
    mainProgram = "claude";
  };
}
