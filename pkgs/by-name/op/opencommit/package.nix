{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
  npm-lockfile-fix,
}:

buildNpmPackage (finalAttrs: {
  pname = "opencommit";
  version = "3.3.11";

  src = fetchFromGitHub {
    owner = "di-sukharev";
    repo = "opencommit";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wYwZlqItbjNjdScvPIx8/8ND3FTRsXwwu6e2WI19HcU=";
    postFetch = ''
      # Fix lockfile issues with bundled dependencies
      ${lib.getExe npm-lockfile-fix} $out/package-lock.json
    '';
  };

  npmDepsHash = "sha256-ID7xdL6loDYsCYzQgLp5daTYsIEyJQGK1VoKIZjlxgU=";

  doCheck = true;

  checkPhase = ''
    runHook preCheck
    npm run test:unit
    runHook postCheck
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Generate git commit messages with an LLM";
    homepage = "https://github.com/di-sukharev/opencommit";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ iamanaws ];
    mainProgram = "oco";
  };
})
